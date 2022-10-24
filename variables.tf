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

variable "cluster_name" {
  description = "EKS cluster name (required)"
}

variable "istio_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "1.16.1"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://istio-release.storage.googleapis.com/charts"
  description = "Helm repository"
}

#variable "istio_global_network" {
#  description = "Istio telementry network name"
#  default     =  "network1"
#}

#variable "istio_global_name" {
#  description = "Istio telementry mesh name"
#  default     = "mesh1"
#}

#variable "istio_pilot_env_PilotSkipValidateTrustDomain" {
#  type        = string
#  default     = true
#  description = "Pilot skip validate trust domain"
#}

#variable "istio_meshConfig_rootNamespace" {
#  description = "The mesh config root namespace"
#  default     = "istio-system"
#}

#variable "istio_meshConfig_enableAutoMtls" {
#  description = "The mesh config enable AutoMTLS"
#  default     = "true"
#}

#variable "ca_private_key" {
#  description = "AWS secret arn to use for ca_private_key (required)"
#  default     = ""
#}

#variable "ca_cert_chain" {
#  description = "AWS secret arn to use for the ca_cert_chain (required)"
#  default     = ""
#}

#variable "ca_cert" {
#  description = "AWS secret arn to use for the ca_cert (required)"
#  default     = ""
#}

#variable "enable_aws_secret_manager_based_certs" {
#  description = "Enable this flag if you provide your own mTLS CA certs for Istio"
#  default     = false
#}
