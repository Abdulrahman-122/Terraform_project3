# use the default virtual private cloud that aws created for us  
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



# build the load_balancer for the default port 80
resource "aws_lb" "lb" {
  name               = var.load_b
  load_balancer_type = "application"
  security_groups    = [aws_security_group.asg.id]
  subnets            = data.aws_subnets.default.ids

}

# build target group for react on port 5173
resource "aws_lb_target_group" "react" {
  name="gym-react"
  port = 5173
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
  health_check {
    path="/"
    port="5173"
    healthy_threshold=2
    unhealthy_threshold = 2
  }
  
}
# build another target group for flask
resource "aws_lb_target_group" "flask" {
  name="gym-flask"
  port = 5000
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
  health_check {
    path="/health"
    port="5000"
    healthy_threshold=2
    unhealthy_threshold = 2
  }
  
}

# attatch instance with react target-group
resource "aws_lb_target_group_attachment" "react"{
  count = var.instance_count
  target_group_arn = aws_lb_target_group.react.arn
  target_id = aws_instance.e2[count.index].id
  port = 5173
}
# then attach it with flask
resource "aws_lb_target_group_attachment" "flask" {
  count = var.instance_count
  target_group_arn = aws_lb_target_group.flask.arn
  target_id = aws_instance.e2[count.index].id
  port = 5000
}
# now forward traffic from aws_lb to react listener

resource "aws_lb_listener" "react_http" {
  load_balancer_arn = aws_lb.lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.react.arn

  }
  
}
# now forward  that traffic from react to flask
resource "aws_lb_listener_rule" "flask_react" {
  listener_arn = aws_lb_listener.react_http.arn
  priority = 100
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.flask.arn
  }
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}



# resource "aws_route53_zone" "main" {
#   name = var.domain_name

# }
# # as you know we made the main zone above called (ummah.com) 
# #then we made reecord
# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "www" #terraform will understand that record name is ; www.ummah.com
#   type    = "A"
#   alias {
#     name                   = aws_lb.lb.dns_name
#     zone_id                = aws_lb.lb.zone_id
#     evaluate_target_health = true
#   }
# }
