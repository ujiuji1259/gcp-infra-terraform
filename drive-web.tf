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

# 鍵は作らず、home-k8s の ServiceAccount drive-web/drive-web から Workload Identity Federation で借用する
resource "google_service_account_iam_member" "drive_web_wif" {
  service_account_id = google_service_account.drive_web.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.home_k8s.name}/subject/system:serviceaccount:drive-web:drive-web"
}
