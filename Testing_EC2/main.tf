# Fetch the latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"] # For Ubuntu Instance.
    #values = ["amzn2-ami-hvm-*-x86_64*"] # For Amazon Instance.
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
  # owners = ["137112412989"] # Amazon owner ID for Amazon Linux AMIs
}


resource "aws_instance" "runner-svr" {
  # ami                    = "ami-0287a05f0ef0e9d9a"      #change ami id for different region
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro" #"t2.large, t2.medium"
  key_name               = "MYLABKEY" #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.runner-VM-SG.id]
  user_data              = templatefile("./runner_install.sh", {})
  count                  = 1
  iam_instance_profile   = aws_iam_instance_profile.runner_profile.name

  tags = {
    Name = "runner-Trivy"
  }

  root_block_device {
    volume_size = 25
  }

  instance_market_options {
    market_type = "spot"
    # spot_options {
    #   max_price = "0.0067" # Set your maximum price for the spot instance
    # }
  }
}

# Add this new resource to handle the provisioning with proper timing
resource "null_resource" "runner_provisioner" {
  depends_on = [aws_instance.runner-svr]
  
  # Only run this after the instance is created
  triggers = {
    instance_id = aws_instance.runner-svr[0].id
  }

  # Copy the actions-runner folder after the instance is created
  provisioner "file" {
    source      = "./actions-runner"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.pem")
      host        = aws_instance.runner-svr[0].public_ip
      timeout     = "5m"
      # Add these timeout settings to give the instance more time to respond
      agent       = false
    }
  }

  # Set appropriate ownership for the copied folder
  provisioner "remote-exec" {
    inline = [
      "echo 'Connected successfully'",
      "ls -la /home/ubuntu/actions-runner",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/actions-runner"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.pem")
      host        = aws_instance.runner-svr[0].public_ip
      timeout     = "5m"
      agent       = false
    }
  }
}

# Add a local-exec provisioner to output the connection command for debugging
resource "null_resource" "connection_info" {
  depends_on = [aws_instance.runner-svr]
  
  provisioner "local-exec" {
    command = "echo 'SSH to instance with: ssh -i MYLABKEY.pem ubuntu@${aws_instance.runner-svr[0].public_ip}'"
  }
}

resource "aws_security_group" "runner-VM-SG" {
  name        = "runner-SG"
  description = "Allow inbound traffic"

  dynamic "ingress" {
    for_each = toset([25, 22, 80, 443, 6443, 465, 8080, 9000, 3000])
    content {
      description = "inbound rule for port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "Custom TCP Port Range"
    from_port   = 2000
    to_port     = 11000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "runner-VM-SG"
  }
}

# IAM Policy for Cost Explorer and IAM permissions
resource "aws_iam_policy" "runner_cost_explorer_policy" {
  name        = "runner-cost-explorer-policy"
  description = "Policy allowing Cost Explorer and IAM account alias access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "iam:ListAccountAliases",
          "ce:GetCostAndUsage"
        ],
        Resource = "*"
      }
    ]
  })
}

# IAM Role for EC2 instance
resource "aws_iam_role" "runner_role" {
  name = "runner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "runner-role"
  }
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "runner_policy_attachment" {
  role       = aws_iam_role.runner_role.name
  policy_arn = aws_iam_policy.runner_cost_explorer_policy.arn
}

# Create an instance profile for the role
resource "aws_iam_instance_profile" "runner_profile" {
  name = "runner-profile"
  role = aws_iam_role.runner_role.name
}

output "instance_ips" {
  value       = aws_instance.runner-svr[*].public_ip
  description = "Public IP addresses of all runner instances"
}

