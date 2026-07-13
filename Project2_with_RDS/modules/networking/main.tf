data "aws_vpc" "default" {
  default = true
}
# usee default subnet
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
# use default security_group with ingress port 80 and egress for all ports
resource "aws_security_group" "asg" {
  name   = var.security_group_name
  vpc_id = data.aws_vpc.default.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0    #any port
    to_port     = 0    #any port
    protocol    = "-1" #any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}




#build security group for Ec2
resource "aws_security_group" "ec2" {
  name="${var.environment}-ec2"
  vpc_id = data.aws_vpc.default.id
  ingress{
    from_port = 5173
    to_port = 5173
    protocol = "tcp"
    security_groups = [aws_security_group.asg.id]

  }
  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    security_groups =[aws_security_group.asg.id]

  }
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
