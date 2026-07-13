terraform {
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

module "web_app" {
  source              = "../modules/web_app/"
  environment         = var.environment
  region              = var.region
  ami_id              = var.ami_id
  instance_count      = var.instance_count
  instance_type       = var.instance_type
  security_group_name = var.security_group_name
  load_b              = var.load_b
  public_key = var.public_key

}
