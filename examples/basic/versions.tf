terraform {
  required_version = "~>1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.60"
    }
    github = {
      source  = "integrations/github"
      version = "~>5.0"
    }
  }
}
