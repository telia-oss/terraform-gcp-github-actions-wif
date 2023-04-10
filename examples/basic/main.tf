module "gha_repo1" {
  source = "../../"

  name_prefix = "demo"
  environment = "development"

  repositories = [
    {
      repository_name = "rickardl/teliacompany-gcp-wif-test"
      environments = [
        {
          environment = "development"
          name_prefix = "app1-dev"
          project_id  = "seismic-shape-293115"
          tags = {
            Environment = "development"
            Application = "App1"
          }
          project_roles = ["roles/compute.networkAdmin", "roles/appengine.appAdmin"]
        }
      ]

    },

  ]
}
