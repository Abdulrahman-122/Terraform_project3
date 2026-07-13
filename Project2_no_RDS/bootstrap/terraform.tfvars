region              = "eu-west-3"
bucket_name         = "hacker1-123bucket"
bucket_tag_name     = "Terraform-bucket"
# dynamodb_table_name = "terraform-locks"

# the default name for variables is terraform.variable here we named it vari_terra.tfvars so we need to some small  work to make it understand that this is the file 
# you need to write those: terraform plan -var-file=vari_terra.tfvars -out=tfplan in order to take these variables and build his stuff on top of it
# then ; terraform apply tfplan
# out said to terraform to save the plan in order to apply it later
# or
# terraform apply -var-file="vari_terra.tfvars"

# or

# terraform plan -var-file="vari_terra.tfvars"

# to solve all of these just name the file;terraform.tfvars
