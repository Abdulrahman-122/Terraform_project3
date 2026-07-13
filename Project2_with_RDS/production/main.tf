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
module "networking" {
  source              = "../modules/networking"
  environment         = var.environment
  security_group_name = var.security_group_name
}
module "database" {
  source                       = "../modules/database"
  region                       = var.region
  sec_group_name               = var.db_sec_group_name
  db_subnet_name               = var.db_sub_name
  db_name                      = var.db_name
  db_password                  = var.db_pass
  db_username                  = var.db_user
  instance_type                = var.db_instance_type
  allocate_storage_for_mariadb = var.db_storage
  ec2_security_group_id        = module.networking.ec2_security_group_id
}
module "web_app" {
  source              = "../modules/web_app/"
  environment         = var.environment
  region              = var.region
  ami_id              = var.ami_id
  instance_count      = var.instance_count
  instance_type       = var.instance_type
  security_group_name = var.security_group_name

  load_b                = var.load_b
  public_key            = var.public_key
  ec2_security_group_id = module.networking.ec2_security_group_id
  alb_security_group_id = module.networking.alb_security_group_id
  database_url          = "mysql+pymysql://${var.db_user}:${var.db_pass}@${module.database.db_address}:${module.database.db_port}/${var.db_name}"

}