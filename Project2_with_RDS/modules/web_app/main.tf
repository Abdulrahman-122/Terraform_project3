# to run this : use; terraform init -backend-config=backend.hcl in order to  make terraform read this file in order to initialize your backend
terraform {
  backend "s3" {

  }
  required_providers {
    aws = {
      version = "~> 5.92"
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = var.region
}

