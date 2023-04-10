# The main.tf file for the terraform-azure-github-actions-wif module
#
# This file contains the core resources and logic for the module,
# integrating GitHub Actions with Workload Identity Federation for Microsoft Azure.
#


# The default tags to apply to all resources in this module
locals {
  tags = merge(var.default_tags, var.user_defined_tags, { "Environment" = var.environment })
}
