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

output "drive_web_service_account_email" {
  description = "drive-web の SA。公開したい Drive フォルダ (閲覧者) と Sheets (編集者) をこのアドレスに共有する"
  value       = google_service_account.drive_web.email
}

output "home_k8s_wif_audience" {
  description = "Pod の projected token の audience / credential config の audience"
  value       = "//iam.googleapis.com/${google_iam_workload_identity_pool_provider.home_k8s.name}"
}
