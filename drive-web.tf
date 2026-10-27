# home-kubernetes の drive-web (Drive フォルダの LAN 内閲覧 + Sheets 読み書き API) 用。
# アクセス範囲は IAM ではなく、対象のフォルダ・シートをこの SA のメールアドレスに共有して絞る。
resource "google_project_service" "drive" {
  service            = "drive.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sheets" {
  service            = "sheets.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "drive_web" {
  account_id   = "drive-web"
  display_name = "drive-web (home-kubernetes)"
  description  = "Reads a shared Drive folder (rclone) and reads/writes shared Sheets for drive-web"
}

# JSON 鍵。1Password の drive-web/serviceAccountJson に入れ、ExternalSecret で Pod に渡す
resource "google_service_account_key" "drive_web" {
  service_account_id = google_service_account.drive_web.name
}
