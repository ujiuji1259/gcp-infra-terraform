terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  # state はとりあえずローカル（.gitignore 済み）。
  # 将来 GCS backend に移したくなったら、state 用バケットを 1 つ用意して
  # 下記コメントを有効化し `terraform init -migrate-state` する。
  # backend "gcs" {
  #   bucket = "ushi-personal-tfstate"
  #   prefix = "restic-backup"
  # }
}
