terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

provider "aws" {
  region = var.region_name
}

# To Create Security Group for EC2 Instance 
resource "aws_security_group" "ProjectSG" {
  name        = "Terraform-SERVER-SG"
  description = "Terraform Server Ports"

  dynamic "ingress" {
    for_each = toset([22, 25, 80, 443, 3000, 6443, 465, 27017])
    content {
      description = "inbound rule for port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Port 2379-2380 is required for etcd-cluster
  ingress {
    description = "etc-cluster Port"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP Port Range"
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP Port Range 30000 to 32767"
    from_port   = 20000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 10250-10260 is required for K8s
  ingress {
    description = "K8s Ports"
    from_port   = 10250
    to_port     = 10260
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Define outbound rules to allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-SVR-SG"
  }

}

# Fetch the latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"] # For Ubuntu Instance.
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

# Separate EC2 Instance for Terraform with IAM Profile and Folder Copy
resource "aws_instance" "terraform_vm" {
  ami           = data.aws_ami.ubuntu.id
  key_name      = var.key_name
  instance_type = var.instance_type
  # iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.ProjectSG.id]
  user_data = templatefile("./scripts/user_data_terraform.sh", {
    aws_access_key_id     = var.aws_access_key_id,
    aws_secret_access_key = var.aws_secret_access_key,
    aws_default_region    = var.aws_default_region
  })

  tags = {
    Name = var.server_name
  }

  root_block_device {
    volume_size = var.volume_size
  }
  # Uncomment the following block if you want to use spot instances
  instance_market_options {
    market_type = var.market_type
    # spot_options {
    #   max_price = "0.0067" # Set your maximum price for the spot instance
    # }
  }

  # Copy the scripts folder after the instance is created
  provisioner "file" {
    source      = "./scripts"
    destination = "/home/ubuntu/scripts"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.pem")
      host        = self.public_ip
    }
  }

  # Set appropriate ownership for the copied folder
  provisioner "remote-exec" {
    inline = [
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/scripts"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.pem")
      host        = self.public_ip
    }
  }

}

# # Custom IAM Policy for AWS Cost CLI
# resource "aws_iam_policy" "eks_custom_policy" {
#   name        = "aws_cost_cli_policy"
#   description = "Custom policy for AWS Cost CLI operations"

#   policy = jsonencode({

#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ce:*"
#             ],
#             "Resource": "*"
#         }
#     ]
#   })
# }

# # Create IAM Role for the runner
# resource "aws_iam_role" "runner_role" {
#   name = "runner-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # Attach the policy to the role
# resource "aws_iam_role_policy_attachment" "runner_policy_attachment" {
#   role       = aws_iam_role.runner_role.name
#   policy_arn = aws_iam_policy.eks_custom_policy.arn
# }

# # Create an instance profile for the role
# resource "aws_iam_instance_profile" "instance_profile" {
#   name = "k8s-cluster-instance-profile"
#   role = aws_iam_role.runner_role.name
# }

output "terraform_vm_public_ip" {
  value = aws_instance.terraform_vm.public_ip
}

output "terraform_vm_private_ip" {
  value = aws_instance.terraform_vm.private_ip
}
