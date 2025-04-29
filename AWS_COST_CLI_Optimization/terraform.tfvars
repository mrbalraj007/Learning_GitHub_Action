# DEFINE ALL YOUR VARIABLES HERE

instance_type = "t2.micro" #T3 Instance
key_name      = "MYLABKEY" # Replace with your key-name without .pem extension
volume_size   = 15
region_name   = "us-east-1"
server_name   = "Terraform-SERVER"
market_type   = "spot" # Set to "spot" if you want to use spot instances
# Note: 
# a. First create a pem-key manually from the AWS console
# b. Copy it in the same directory as your terraform code
