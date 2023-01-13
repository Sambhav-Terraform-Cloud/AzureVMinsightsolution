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

variable "snow_username" {}

variable "snow_password" {}

variable "snow_url" {}
