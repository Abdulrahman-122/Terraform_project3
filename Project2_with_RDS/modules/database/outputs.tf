
output "db_address" {
    value=aws_db_instance.RDS.address

}
output "db_port" {
  value=aws_db_instance.RDS.port
}
output "db_endpoint" {
  value=aws_db_instance.RDS.endpoint
}