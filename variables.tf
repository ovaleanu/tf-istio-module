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

variable "istio_base_settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
}

variable "istiod_global_network" {
  description = "Istio telementry network name"
  default     = "network1"
}

variable "istiod_global_meshID" {
  description = "Istio telementry mesh name"
  default     = "mesh1"
}

variable "istiod_meshConfig_accessLogFile" {
  description = "The mesh config access log file"
  default     = "/dev/stdout"
}

variable "istiod_meshConfig_rootNamespace" {
  description = "The mesh config root namespace"
  default     = "istio-system"
}

variable "istiod_meshConfig_enableAutoMtls" {
  description = "The mesh config enable AutoMtls"
  default     = "true"
}

variable "istiod_meshConfig_trustDomain" {
  description = "The trust domain corresponds to the trust root of a system"
  default     = "td1"
}