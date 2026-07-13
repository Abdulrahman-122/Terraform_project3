
output "public-ip-ec2" {
  value = module.web_app.public-ip-ec2

}
output "dns-ec2" {
  value = module.web_app.dns-ec2
}
output "private-ip" {
  value = module.web_app.private-ip
}
output "alb_dns_name" {
  value = module.web_app.alb_dns_name
}


# output "route_53_zone" {
#   value = aws_route53_zone.main.name
# }

