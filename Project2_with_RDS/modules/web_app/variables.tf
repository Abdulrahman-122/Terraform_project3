variable "region" {
  description = "aws region"
  type        = string
}
variable "security_group_name" {
  description = "Name of security group in order to build your instances"
  type        = string
}
variable "ami_id" {
  description = "specify the type of the amazon image that you want to use"
  type        = string
}
variable "instance_type" {
  type = string
}
variable "instance_count" {
  type = number
}
variable "load_b" {
  description = "Define the name of the load balancer"
  type        = string
}
# variable "domain_name" {
#   description = "Define the name of the rout53"
#   type        = string
# }

variable "environment" {
  description = "The name of the environment"
  type        = string
}
variable "public_key" {
  type = string
}
variable "alb_security_group_id" {
    type = string
}
variable "ec2_security_group_id" {
  type = string
}
variable "database_url" {
  type=string
  sensitive = true
}