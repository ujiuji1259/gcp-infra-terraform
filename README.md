# gcp-infra-terraform

自宅インフラ（home-kubernetes）から使う GCP リソースを Terraform で管理する。

## restic-backup

home-kubernetes クラスタの NFS (`/mnt/ssd`) を restic でバックアップする先の
GCS バケットと、書き込み用サービスアカウントを作成する。

作成されるもの:

- `google_storage_bucket.restic` — `ushi-personal-restic-backup`（versioning 有効）
- `google_service_account.restic` — `restic-backup@<project>.iam.gserviceaccount.com`
- 上記バケットへの `roles/storage.objectAdmin` バインド
- SA 鍵（JSON）

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

### 適用後にやること（1Password 登録）

`home-kubernetes-app` の ExternalSecret はアイテム `nfs-backup-gcs` を参照する。
以下を 1Password（vault: おうちkubernetes）に登録する。

| フィールド | 取得方法 |
|---|---|
| `credentials` | `terraform output -raw service_account_key_json` |
| `projectId`   | `terraform output -raw project_id` |
| `resticPassword` | `openssl rand -base64 32`（手動生成。※紛失するとバックアップ復元不能） |

`home-kubernetes-app/nfs-backup/cronjob.yaml` の `RESTIC_REPOSITORY` が
`terraform output -raw restic_repository` と一致していることを確認する。

### state について

state はローカル管理（`.gitignore` 済み）。SA 鍵などが state に含まれるため
コミットしないこと。GCS backend に移す場合は `versions.tf` のコメント参照。
