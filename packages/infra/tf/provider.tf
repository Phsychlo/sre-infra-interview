provider "aws" {
  region = var.region
  # profile = var.profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
      #note bump from ~3.0
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }

  }
  backend "s3" {
    encrypt = true
    # account_id     = "188556555096"
    bucket         = "jnr-interview-tf"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "jnr-lock-state"

  }
}