
resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio-base" {
  repository      = var.helm_repo_url
  chart           = "base"
  name            = "istio-base"
  namespace       = kubernetes_namespace.istio_system.metadata.0.name
  version         = var.istio_version
  timeout         = 120
  cleanup_on_fail = var.cleanup_on_fail
  force_update    = var.force_update
  depends_on      = [kubernetes_namespace.istio_system]

  values = [
    yamlencode(var.istio_base_settings)
  ]
}

resource "helm_release" "istiod" {
  repository      = var.helm_repo_url
  chart           = "istiod"
  name            = "istiod"
  namespace       = kubernetes_namespace.istio_system.metadata.0.name
  version         = var.istio_version
  timeout         = 120
  cleanup_on_fail = var.cleanup_on_fail
  force_update    = var.force_update
  depends_on      = [helm_release.istio-base]

  values = [
    yamlencode(
      {
        global = {
          network = var.istiod_global_network
          meshID = var.istiod_global_meshID
          multiCluster = {
            clusterName = var.cluster_name
          }
        }
        meshConfig = {
          rootNamespaces = var.istiod_meshConfig_rootNamespace
          trustDomain = var.istiod_meshConfig_trustDomain
          accessLogFile = var.istiod_meshConfig_accessLogFile
          enableAutoMtls = var.istiod_meshConfig_enableAutoMtls
        }
      }
    )
  ]
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    name = "istio-ingress"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "helm_release" "istio-ingressgateway" {
  repository      = var.helm_repo_url
  chart           = "gateway"
  name            = "istio-ingressgateway"
  namespace       = kubernetes_namespace.istio_ingress.metadata.0.name
  version         = var.istio_version
  timeout         = 120
  cleanup_on_fail = var.cleanup_on_fail
  force_update    = var.force_update
  depends_on      = [kubernetes_namespace.istio_ingress, helm_release.istiod]
}
