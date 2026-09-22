# gcp-infra-terraform

自宅インフラ（home-kubernetes）から使う GCP リソースを Terraform で管理する。

## longhorn-backup

home-kubernetes クラスタの Longhorn が S3 互換バックアップターゲットとして使う
GCS バケットと、書き込み用サービスアカウント（HMAC キー）を作成する。

作成されるもの:

- `google_storage_bucket.longhorn` — `ushi-personal-longhorn-backup`
- `google_service_account.longhorn` — `longhorn-backup@<project>.iam.gserviceaccount.com`
- 上記バケットへの `roles/storage.objectAdmin` バインド
- HMAC キー（Longhorn の BackupTarget secret に設定する access key / secret key）

### 前提

- gcloud で認証済み（`gcloud auth application-default login`）
- 対象プロジェクトで Cloud Storage / IAM API が有効
  （未有効なら `gcloud services enable storage.googleapis.com iam.googleapis.com --project ushi-personal`）

### 適用

```bash
terraform init
terraform plan
terraform apply
```

### state について

state は GCS backend（`gs://tf-states-ushi/gcp-infra-terraform/`）で管理する。
ローカルに state ファイルは残らない。

## 廃止: restic-backup

home-kubernetes の NFS (`/mnt/ssd`) を restic でバックアップする用途で使っていたが、
Longhorn backup への移行に伴い 2026-09 に廃止・削除した
（`ushi-personal-restic-backup` バケットおよび `restic-backup` SA を削除済み）。
