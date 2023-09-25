module "gha_repo1" {
  source = "../../"

  name_prefix = "demo"
  environment = "development"

  repositories = [
    {
      repository_name = "terraform-gcp-github-actions-wif"
      environments = [
        {
          environment = "development"
          name_prefix = "demo123-dev"
          project_id  = "seismic-shape-293115"
          tags = {
            Environment = "development"
            Application = "Demo1"
          }
          project_roles = ["roles/compute.networkAdmin", "roles/appengine.appAdmin"]
        },

        {
          environment = "production"
          name_prefix = "demo123-prod"
          project_id  = "seismic-shape-293115"
          tags = {
            Environment = "production"
            Application = "Demo2"
          }
          project_roles = ["roles/compute.networkAdmin", "roles/appengine.appAdmin"]
        }
      ]

    },

  ]
}
