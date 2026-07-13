terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
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
  domain_name         = var.domain_name


}
