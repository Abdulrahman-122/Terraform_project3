# to run this : use; terraform init -backend-config=backend.hcl in order to  make terraform read this file in order to initialize your backend
terraform {
  backend "s3"{

  }
  required_providers {
    aws={
    version="~> 5.92"
    source = "hashicorp/aws"
  }
}
}
provider "aws"{
    region=var.region
}
# use the default virtual private cloud that aws created for us  
data "aws_vpc" "default"{
    default = true
}
# usee default subnet
data "aws_subnets" "default"{
    filter{
        name="vpc-id"
        values=[data.aws_vpc.default.id]
    }
}
# use default security_group with ingress port 80 and egress for all ports
resource "aws_security_group" "asg"{
    name=var.security_group_name
    vpc_id=data.aws_vpc.default.id
    ingress{
        from_port=80
        to_port=80
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    egress{
        from_port = 0      #any port
        to_port = 0       #any port
        protocol = "-1"  #any protocol
        cidr_blocks = ["0.0.0.0/0"]
    }

} 
# make 2 types of ec2 with t3.micro
resource "aws_instance" "e2"{
    count=var.instance_count
    ami=var.ami_id
    instance_type=var.instance_type
    tags={
        Name="Web-${count.index}"
    }
    vpc_security_group_ids = [
        aws_security_group.asg.id
    ]
    user_data = <<-EOF
            #!/bin/bash
            apt update
            apt install -y python3
            mkdir -p  /var/www/html
            echo "<h1>Hey,how it's going!!!</h1>" > /var/www/html/index.html
            cd /var/www/html
            nohup python3 -m http.server 80 &
            EOF
}
# build the load_balancer
resource "aws_lb" "lb"{
    name=var.load_b
    load_balancer_type="application"
    security_groups=[aws_security_group.asg.id]
    subnets=data.aws_subnets.default.ids

}
# build the target_group of load_balancer
resource "aws_lb_target_group" "web"{
    name="lb-target-group"
    port=80
    protocol="HTTP"
    vpc_id=data.aws_vpc.default.id
    health_check{
        path="/"
    }
}
# use load_balancer attatchment in order to connect load-balancer with two instances
resource "aws_lb_target_group_attachment"  "web" {
    count=2
    target_group_arn=aws_lb_target_group.web.arn
    target_id = aws_instance.e2[count.index].id
    port=80
} 
# use listener in order to listen for port 80
resource "aws_lb_listener" "listen"{
    load_balancer_arn=aws_lb.lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type="forward"
      target_group_arn=aws_lb_target_group.web.arn
    }
}

resource "aws_route53_zone" "main" {
    name=var.domain_name
  
}
# as you know we made the main zone above called (ummah.com) 
#then we made reecord
resource "aws_route53_record" "www"{
    zone_id = aws_route53_zone.main.zone_id
    name="www" #terraform will understand that record name is ; www.ummah.com
    type="A"
    alias{
        name = aws_lb.lb.dns_name
        zone_id=aws_lb.lb.zone_id
        evaluate_target_health= true
        }
    }