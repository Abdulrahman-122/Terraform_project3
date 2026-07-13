provider "aws"{
    region=var.region
}
data "aws_vpc" "default"{
    default=true
}
data "aws_subnets" "default"{
    filter{
        name="vpc-id"   #fixed name so don't  make it variable
        values = [data.aws_vpc.default.id]
    }
}
resource "aws_security_group"  "sg"{
    name=var.sec_group_name
    vpc_id=data.aws_vpc.default.id
    ingress{
        from_port = 3306
        to_port = 3306
        protocol="tcp"
        security_groups = [var.ec2_security_group_id]
        }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }   
}
resource "aws_db_subnet_group" "mariadb"{
    name=var.db_subnet_name
    subnet_ids=data.aws_subnets.default.ids
}
resource "aws_db_parameter_group" "mariadb" {
  name   = "gym-mariadb-parameters"
  family = "mariadb11.8"

  parameter {
    name  = "require_secure_transport"
    value = "0"
  }
}
resource "aws_db_instance" "RDS" {
    allocated_storage=var.allocate_storage_for_mariadb
    engine = "mariadb"
    instance_class=var.instance_type
    db_name=var.db_name
    username=var.db_username
    password=var.db_password
    publicly_accessible=false
    skip_final_snapshot=true
    vpc_security_group_ids=[aws_security_group.sg.id]
    db_subnet_group_name=aws_db_subnet_group.mariadb.name
    storage_encrypted = true
    parameter_group_name = aws_db_parameter_group.mariadb.name
}



# note:
# We use the sensitive argument in Terraform to 
# prevent passwords and secrets from being displayed in 
# plain text in terminal outputs, logs, or plan files.