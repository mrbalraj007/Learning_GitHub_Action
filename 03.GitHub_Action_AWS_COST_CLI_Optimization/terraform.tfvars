# DEFINE ALL YOUR VARIABLES HERE

instance_type         = "t2.micro" #T3 Instance
key_name              = "MYLABKEY" # Replace with your key-name without .pem extension
volume_size           = 15
region_name           = "us-east-1"
server_name           = "AWS-Cost-SVR"
market_type           = "spot"                                     # Set to "spot" if you want to use spot instances
aws_access_key_id     = "xxxxxxxxxx"                     # "YOUR_AWS_ACCESS_KEY" # Replace with your AWS access key
aws_secret_access_key = "xxxxxxxxxxxxxxxxxxxx" # "YOUR_AWS_SECRET_KEY" # Replace with your AWS secret key
aws_default_region    = "us-east-1"                                # Should match the region_name above

# Note: 
# a. First create a pem-key manually from the AWS console
# b. Copy it in the same directory as your terraform code
