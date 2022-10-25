variable "cleanup_on_fail" {
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  default     = true
  type        = bool
}

variable "force_update" {
  description = "Force resource update through delete/recreate if needed"
  default     = false
  type        = bool
}

variable "timeout" {
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
  default     = 120
}

variable "istio_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "1.15.2"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://istio-release.storage.googleapis.com/charts"
  description = "Helm repository"
}

variable "cluster_name" {
  description = "k8s cluster name, required"
}

variable "subnets" {
  description = "provide the subnets used by load balancer for istio gateway"
  default     = []
}

variable "istio_aws_elb_gw_enabled" {
  description = "enable or disable the istio gw install that has an ELB for load balancer, default true"
  default     = false
}

variable "elb_load_balancer" {
  default = {
    "service" = {
      "annotations" = {
        "service.beta.kubernetes.io/aws-load-balancer-internal" = "true"
      },
      "ports" = [
        {
          "name"       = "https"
          "port"       = 443
          "protocol"   = "TCP"
          "targetPort" = 443
        },
        {
          "name"       = "http2"
          "port"       = 80
          "protocol"   = "TCP"
          "targetPort" = 80
        },
        {
          "name"       = "status-port"
          "port"       = 15021
          "protocol"   = "TCP"
          "targetPort" = 15021
        },
        {
          "name"       = "grpc"
          "port"       = 50051
          "protocol"   = "TCP"
          "targetPort" = 50051
        },
        {
          "name"       = "tls"
          "port"       = 15443
          "protocol"   = "TCP"
          "targetPort" = 15443
        },
      ]
    }
  }
}

variable "istio_base_settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
}

variable "istiod_settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
}

variable "istio_meshconfig_network" {
  description = "Istio telementry network name"
  default     = "network1"
}

variable "istio_meshconfig_mesh_name" {
  description = "Istio telementry mesh name"
  default     = "mesh1"
}

variable "ca_private_key" {
  description = "the aws secret arn to use for ca_private_key"
  default     = ""
}
variable "ca_cert_chain" {
  description = "the aws secret arn to use for the ca_cert_chain"
  default     = ""
}
variable "ca_cert" {
  description = "the aws secret arn to use for the ca_cert"
  default     = ""
}
variable "enable_aws_secret_manager_based_certs" {
  description = "If you would like to provide your own mTLS CA certs for istio to use, enable this flag and input AWS secret ARNs required"
  default     = false
}
