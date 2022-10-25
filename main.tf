locals {
  subnets = join("\\,", var.subnets)
}

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
  timeout         = var.timeout
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
  timeout         = var.timeout
  cleanup_on_fail = var.cleanup_on_fail
  force_update    = var.force_update
  depends_on      = [helm_release.istio-base]

  set {
    name  = "global.meshID"
    value = var.istio_meshconfig_mesh_name
  }

  set {
    name  = "global.network"
    value = var.istio_meshconfig_network
  }

  set {
    name  = "meshConfig.rootNamespace"
    value = "istio-system"
  }

  set {
    name  = "meshConfig.trustDomain"
    value = var.cluster_name
  }

  set {
    name  = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }

  values = [
    yamlencode(var.istiod_settings)
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
  timeout         = var.timeout
  cleanup_on_fail = var.cleanup_on_fail
  force_update    = var.force_update
  depends_on      = [kubernetes_namespace.istio_ingress, helm_release.istiod]

  set {
    name  = "labels.topology\\.istio\\.io/network"
    value = var.istio_meshconfig_network
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-subnets"
    value = local.subnets
  }

  values = [
    yamlencode(var.elb_load_balancer))
  ]
}

data "aws_secretsmanager_secret_version" "ca_private_key" {
  count     = var.enable_aws_secret_manager_based_certs ? 1 : 0
  secret_id = var.ca_private_key
}
data "aws_secretsmanager_secret_version" "ca_cert_chain" {
  count     = var.enable_aws_secret_manager_based_certs ? 1 : 0
  secret_id = var.ca_cert_chain
}
data "aws_secretsmanager_secret_version" "ca_cert" {
  count     = var.enable_aws_secret_manager_based_certs ? 1 : 0
  secret_id = var.ca_cert
}
resource "kubernetes_secret" "istio-ca" {
  count      = var.enable_aws_secret_manager_based_certs ? 1 : 0
  depends_on = [helm_release.istio-base]
  metadata {
    name      = "cacerts"
    namespace = "istio-system"
  }
  data = {
    "ca-cert.pem"    = data.aws_secretsmanager_secret_version.ca_cert[count.index].secret_string
    "cert-chain.pem" = data.aws_secretsmanager_secret_version.ca_cert[count.index].secret_string
    "ca-key.pem"     = data.aws_secretsmanager_secret_version.ca_private_key[count.index].secret_string
    "root-cert.pem"  = data.aws_secretsmanager_secret_version.ca_cert_chain[count.index].secret_string
  }
}
