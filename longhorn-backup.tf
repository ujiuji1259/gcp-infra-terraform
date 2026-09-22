locals {
  longhorn_bucket_name = "${var.project_id}-longhorn-backup"
}

# home-kubernetes クラスタの Longhorn がバックアップ先(S3 互換)として使う GCS バケット
resource "google_storage_bucket" "longhorn" {
  name                        = local.longhorn_bucket_name
  location                    = var.bucket_location
  storage_class               = "NEARLINE"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
}

# Longhorn 専用サービスアカウント（このバケットへの書き込みのみ、HMAC キーで S3 互換認証）
resource "google_service_account" "longhorn" {
  account_id   = "longhorn-backup"
  display_name = "Longhorn backup writer"
  description  = "HMAC-key holder for Longhorn's S3-compatible backup target"
}

resource "google_storage_bucket_iam_member" "longhorn_object_admin" {
  bucket = google_storage_bucket.longhorn.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.longhorn.email}"
}

# Longhorn の S3 互換バックアップターゲット用 HMAC キー
resource "google_storage_hmac_key" "longhorn" {
  service_account_email = google_service_account.longhorn.email
}
