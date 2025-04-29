# AWS Region
aws_region = "us-east-1"

# AMI Configuration
ami_filter_name         = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"
ami_virtualization_type = "hvm"
ami_owners              = ["099720109477"]

# Instance Configuration
instance_type    = "t3.small"
key_name         = "MYLABKEY"
private_key_path = "MYLABKEY.pem"
instance_tags = {
  Name = "runner-Trivy"
}
root_volume_size = 25

# Security Group Configuration
sg_name        = "runner-SG"
sg_description = "Allow inbound traffic"
sg_ingress_ports = [25, 22, 80, 443, 6443, 465, 8080, 9000, 3000]
sg_custom_port_range = {
  from_port = 2000
  to_port   = 11000
}
sg_cidr_blocks = ["0.0.0.0/0"]
