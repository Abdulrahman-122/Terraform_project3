variable "region"{
    description = "region_name"
    type=string
}
variable "sec_group_name" {
    description = "Name of security group in order to build your db engine"
    type=string
}
variable "db_subnet_name"{
    description = "Name of subnet that  db will locate in"
    type=string
}
variable "instance_type"{
    type=string
}
variable "db_name"{
    type=string
}
variable "db_username"{
    type=string
}
variable "db_password"{
    type=string
    sensitive = true
}
variable "allocate_storage_for_mariadb" {
  type=number
  sensitive = true
}
variable "ec2_security_group_id"{
    type=string
    description = "Security group ID for of the ec2 instance"
}
