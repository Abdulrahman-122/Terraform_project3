# make 2 types of ec2 with t3.micro
resource "aws_instance" "e2" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  user_data = file("${path.module}/user_data.sh")
  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

   tags = {
    Name = "${var.environment}-${count.index}"
  }
  key_name = aws_key_pair.gym.key_name
}

