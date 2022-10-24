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