# Bootstraping
terraform {
  required_providers {
    aws = {
      version = "~> 5.92"
      source  = "hashicorp/aws"
    }
  }
  required_version = "1.15.7"
}
provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "buck" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_tag_name
  }
}
# here we made versioning for the bucket in order to save the old files 
resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.buck.id
  versioning_configuration {
    status = "Enabled"
  }
}
# then here we made encryption for the bucket in order to encode everything in it
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.buck.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption_algorithm
    }
  }
}
# # here we asked for dynamodb 
# # we used it in order to block more than two applies at a time
#don't use it as in today -> s3 has the feature to lock the states from many processes and just apply the change from the first process
# resource "aws_dynamodb_table" "db" {
#   name         = var.dynamodb_table_name
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

