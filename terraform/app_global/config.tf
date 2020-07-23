terraform {
  required_version = "= 0.12.29"

  backend "remote" {
    organization = "owenbendavies"

    workspaces {
      prefix = "cms-"
    }
  }
}
