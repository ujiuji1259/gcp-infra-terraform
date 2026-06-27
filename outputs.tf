output "bucket_name" {
  description = "restic backup bucket name"
  value       = google_storage_bucket.restic.name
}

output "restic_repository" {
  description = "RESTIC_REPOSITORY value for the CronJob (home-kubernetes-app/nfs-backup/cronjob.yaml)"
  value       = "gs:${google_storage_bucket.restic.name}:/restic"
}

output "project_id" {
  description = "GOOGLE_PROJECT_ID for the CronJob (1Password: nfs-backup-gcs/projectId)"
  value       = var.project_id
}

output "service_account_email" {
  value = google_service_account.restic.email
}

# `terraform output -raw service_account_key_json` で取り出して
# 1Password (nfs-backup-gcs/credentials) に貼る
output "service_account_key_json" {
  description = "SA key JSON. Put into 1Password nfs-backup-gcs/credentials."
  value       = base64decode(google_service_account_key.restic.private_key)
  sensitive   = true
}
