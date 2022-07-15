# this backend is in terraform cloud, just for storing state
terraform {
  backend "remote" {
    organization = "chaotic-good"

    workspaces {
      name = "code-corpus-api"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19"
    }
  }

  required_version = ">= 1.2.2"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}


