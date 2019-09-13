# Create the Service Account to run the Cloud Functions with
resource "google_service_account" "sa" {
  project      = var.project
  account_id   = var.account_id
  display_name = var.display_name != "Managed by Terraform" ? "${var.display_name} (Managed by Terraform)" : "Managed by Terraform"
}

# Add required roles to the Service Account
resource "google_project_iam_member" "sa-iam" {
  count   = length(var.roles)
  project = var.project
  role    = var.roles[count.index]
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# @TODO: Add generate_key flag
# resource "google_service_account_key" "keys" {
#   count              = var.generate_key ? 1 : 0
#   service_account_id = google_service_account.sa.email
# }