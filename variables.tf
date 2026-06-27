variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "Default region for the provider"
  default     = "asia-northeast1"
}

variable "bucket_location" {
  type        = string
  description = "Location for the restic backup bucket"
  default     = "ASIA-NORTHEAST1"
}
