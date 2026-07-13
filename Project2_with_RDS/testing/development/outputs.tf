output "public_ip"{
    value=aws_instance.e2[*].public_ip

}
output "dns-ec2"{
    value=aws_instance.e2[*].public_dns
}
output "private-ip" {
    value = aws_instance.e2[*].private_ip
}
output "route_53_zone"{
    value=aws_route53_zone.main.name
}