output "public-ip-ec2" {
  value = aws_instance.e2[*].public_ip

}
output "dns-ec2" {
  value = aws_instance.e2[*].public_dns
}
output "private-ip" {
  value = aws_instance.e2[*].private_ip
}

output "alb_dns_name" {
  value=aws_lb.lb.dns_name
}
