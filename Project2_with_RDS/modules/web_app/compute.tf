# make 2 types of ec2 with t3.micro
resource "aws_instance" "e2" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  user_data = templatefile("${path.module}/user_data.sh.tpl",{
    database_url=var.database_url
  })
  vpc_security_group_ids = [
    var.ec2_security_group_id
  ]

   tags = {
    Name = "${var.environment}-${count.index}"
  }
  key_name = aws_key_pair.gym.key_name
}

