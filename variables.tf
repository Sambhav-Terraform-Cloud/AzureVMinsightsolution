variable "location" {
  description = "region"
  type        = string
}

variable "scope" {
  type        = string
}

variable "cpuThresoldPercent" {
  type        = string
}

variable "severity" {
  type        = string
}

variable "frequency" {
  type        = string
}

variable "window_size" {
  type        = string
}

variable "snow_username" {
  type        = string
  default     = ""
  description = "Terraform Cloud Workspace Variable"
}

variable "snow_password" {
  type        = string
  default     = ""
  description = "Terraform Cloud Workspace Variable"
  sensitive   = true
}

variable "snow_url" {
  type        = string
  default     = ""
  description = "Terraform Cloud Workspace Variable"
}
