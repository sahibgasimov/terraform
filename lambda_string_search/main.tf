provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

terraform {
  required_version = ">= 0.15.1"
}


