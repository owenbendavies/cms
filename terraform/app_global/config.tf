terraform {
  required_version = "= 0.12.28"

  backend "remote" {
    organization = "owenbendavies"

    workspaces {
      prefix = "cms-"
    }
  }
}
