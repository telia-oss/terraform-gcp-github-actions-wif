# Terraform GCP GitHub Actions Workload Identity Federation (WIF) - Basic Example

This example demonstrates the basic usage of the `terraform-gcp-github-actions-wif` module to set up Workload Identity Federation for a GitHub Actions environment.

> **WARNIG:** Clean this exampe up from sensitive data before sharing it with others.

> **NOTE:** This example uses the `terraform-gcp-github-actions-wif` module from the root of the repository. In a real-world scenario, you would use the module from the [Terraform Registry](https://registry.terraform.io/modules/telia-oss/terraform-gcp-github-actions-wif).

> **NOTE:** You need to set the owner attribute in the Github provider block. [Docs](https://registry.terraform.io/providers/integrations/github/latest/docs#owner)

## Usage

1. Run `terraform init` to initialize the Terraform working directory.
2. Run `export GITHUB_TOKEN=$(gh auth token)` to set the Github Token (You need the Github CLI for this)
3. Run `terraform apply` to create the resources.
4. Verify the resources created by checking the output values.

## Inputs

No inputs.

## Outputs

> **NOTE:** The output values are sensitive and should be handled with care.
