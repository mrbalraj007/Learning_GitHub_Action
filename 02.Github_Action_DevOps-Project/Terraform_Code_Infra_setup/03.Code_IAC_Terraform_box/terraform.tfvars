# DEFINE ALL YOUR VARIABLES HERE

instance_type = "t2.medium" #T3 Instance
key_name      = "MYLABKEY" # Replace with your key-name without .pem extension
volume_size   = 30
region_name   = "us-east-1"
server_name   = "Terraform-SERVER"

# Note: 
# a. First create a pem-key manually from the AWS console
# b. Copy it in the same directory as your terraform code
