output "longhorn_bucket_name" {
  description = "Longhorn backup bucket name"
  value       = google_storage_bucket.longhorn.name
}

output "longhorn_service_account_email" {
  value = google_service_account.longhorn.email
}

output "longhorn_hmac_access_id" {
  description = "S3 互換 access key ID (Longhorn の BackupTarget secret に設定)"
  value       = google_storage_hmac_key.longhorn.access_id
}

output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}
