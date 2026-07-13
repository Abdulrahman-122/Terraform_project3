variable "region" {
  description = "AWS Region"
  type        = string
}
variable "bucket_name" {
  description = "hacker1-123bucket"
  type        = string

}
variable "bucket_tag_name" {
  description = "Tag name of the bucket"
  type        = string
}
# variable "dynamodb_table_name" {
#   description = "terraform-locks"
#   type        = string
# }
variable "encryption_algorithm" {
  description = "server-side encryption algorithm"
  type        = string
  default     = "AES256"
}