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

#resource "helm_release" "istio-cni" {
#  repository = var.helm_repo_url
#  chart      = "cni"
#  name       = "istio-cni"
#  namespace  = "kube-system"
#  version    = var.istio_version
#  timeout          = var.timeout
#  cleanup_on_fail  = var.cleanup_on_fail
#  force_update     = var.force_update
#  depends_on = [helm_release.istio-base]
#}

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

#  values = [
#    yamlencode(
#      {
#        global = {
#          network = var.istio_global_network
#          meshID  = var.istio_global_name
#          multiCluster = {
#            clusterName = var.cluster_name
#          }
#        }
#        pilot = {
#          env = {
#            PILOT_SKIP_VALIDATE_TRUST_DOMAIN = var.istio_pilot_env_PilotSkipValidateTrustDomain
#          }
#        }
#        meshConfig = {
#          rootNamespace  = var.istio_meshConfig_rootNamespace
#          trustDomain    = var.cluster_name
#          enableAutoMtls = var.istio_meshConfig_enableAutoMtls
#        }
#      }
#    )
#  ]
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

#data "aws_secretsmanager_secret_version" "ca_private_key" {
#  count     = var.enable_aws_secret_manager_based_certs ? 1 : 0
#  secret_id = var.ca_private_key
#}

#data "aws_secretsmanager_secret_version" "ca_cert_chain" {
#  count     = var.enable_aws_secret_manager_based_certs ? 1 : 0
#  secret_id = var.ca_cert_chain
#}

#data "aws_secretsmanager_secret_version" "ca_cert" {
#  count     = var.enable_aws_secret_manager_based_certs ? 1 : 0
#  secret_id = var.ca_cert
#}

#resource "kubernetes_secret" "istio-ca" {
#  count      = var.enable_aws_secret_manager_based_certs ? 1 : 0
#  depends_on = [helm_release.istio-base]

#  metadata {
#    name      = "cacerts"
#    namespace = "istio-system"
#  }

#  data = {
#    "ca-cert.pem"    = data.aws_secretsmanager_secret_version.ca_cert[count.index].secret_string
#    "cert-chain.pem" = data.aws_secretsmanager_secret_version.ca_cert[count.index].secret_string
#    "ca-key.pem"     = data.aws_secretsmanager_secret_version.ca_private_key[count.index].secret_string
#    "root-cert.pem"  = data.aws_secretsmanager_secret_version.ca_cert_chain[count.index].secret_string
#  }
#}