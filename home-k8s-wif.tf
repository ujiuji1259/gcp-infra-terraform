# home-kubernetes クラスタの ServiceAccount トークン (OIDC) を GCP に信頼させる Workload Identity Federation。
# クラスタの API server は外部公開していないので、JWKS (公開鍵) を直接登録する。
# クラスタを再構築して SA 署名鍵が変わったら home-k8s-jwks.json を取り直して apply する:
#   kubectl get --raw /openid/v1/jwks | jq . > home-k8s-jwks.json
resource "google_project_service" "sts" {
  service            = "sts.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iamcredentials" {
  service            = "iamcredentials.googleapis.com"
  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "home_k8s" {
  workload_identity_pool_id = "home-k8s"
  display_name              = "home-kubernetes"
  description               = "ServiceAccount tokens of the home kubernetes cluster"
}

resource "google_iam_workload_identity_pool_provider" "home_k8s" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.home_k8s.workload_identity_pool_id
  workload_identity_pool_provider_id = "home-k8s"
  display_name                       = "home-kubernetes"

  # google.subject = system:serviceaccount:<namespace>:<name>
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }

  oidc {
    issuer_uri = "https://kubernetes.default.svc.cluster.local"
    jwks_json  = file("${path.module}/home-k8s-jwks.json")
    # allowed_audiences 省略時は provider のフルリソース名 (credential config の audience) が許可される
  }
}
