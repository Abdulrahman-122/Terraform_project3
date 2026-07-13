resource "aws_key_pair" "gym" {
  key_name = "${var.environment}-gym-key"
  public_key = var.public_key
  
}