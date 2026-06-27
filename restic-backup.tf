locals {
  bucket_name = "${var.project_id}-restic-backup"
}

# home-kubernetes クラスタの NFS (/mnt/ssd) を restic でバックアップする先のバケット
resource "google_storage_bucket" "restic" {
  name                        = local.bucket_name
  location                    = var.bucket_location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  force_destroy               = false

  # 誤 prune / 誤削除に対する保険として旧バージョンを残す
  versioning {
    enabled = true
  }

  # 旧バージョンは 30 日 or 直近 3 世代を超えたら掃除（コスト抑制）
  lifecycle_rule {
    condition {
      age                = 30
      with_state         = "ARCHIVED"
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }
}

# restic 専用サービスアカウント（このバケットへの書き込みのみ）
resource "google_service_account" "restic" {
  account_id   = "restic-backup"
  display_name = "restic NFS backup writer"
}

resource "google_storage_bucket_iam_member" "restic_object_admin" {
  bucket = google_storage_bucket.restic.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.restic.email}"
}

# 1Password (nfs-backup-gcs/credentials) に入れる SA 鍵
resource "google_service_account_key" "restic" {
  service_account_id = google_service_account.restic.name
}
