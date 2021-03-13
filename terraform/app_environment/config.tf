terraform {
  backend "remote" {
    organization = "owenbendavies"

    workspaces {
      prefix = "cms-"
    }
  }
}
