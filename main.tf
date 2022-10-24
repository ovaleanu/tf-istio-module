resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "helm_release" "istio-base" {
  repository = var.helm_repo_url
  chart      = "base"
  name       = "istio-base"
  namespace  = kubernetes_namespace.istio_system.metadata.0.name
  version    = var.istio_version
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail
  force_update     = var.force_update
  depends_on = [kubernetes_namespace.istio_system]
}

resource "helm_release" "istiod" {
  repository = var.helm_repo_url
  chart      = "istiod"
  name       = "istiod"
  namespace  = kubernetes_namespace.istio_system.metadata.0.name
  version    = var.istio_version
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail
  force_update     = var.force_update
  depends_on = [kubernetes_namespace.istio_system, helm_release.istio-base]
}


resource "helm_release" "istio-ingressgateway" {
  repository = var.helm_repo_url
  chart      = "gateway"
  name       = "istio-ingressgateway"
  namespace  = kubernetes_namespace.istio_system.metadata.0.name
  version    = var.istio_version
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail
  force_update     = var.force_update
  depends_on = [kubernetes_namespace.istio_system, helm_release.istiod]
}