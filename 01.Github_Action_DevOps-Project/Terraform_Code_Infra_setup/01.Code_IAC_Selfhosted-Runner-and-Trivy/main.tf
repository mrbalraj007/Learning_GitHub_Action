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
  instance_type          = "t2.medium" #"t2.large"
  key_name               = "MYLABKEY"  #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.runner-VM-SG.id]
  user_data              = templatefile("./runner_install.sh", {})

  tags = {
    Name = "runner-Trivy"
  }

  root_block_device {
    volume_size = 25
  }

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = "0.0109" # Set your maximum price for the spot instance
    }
  }

  # Copy the actions-runner folder after the instance is created
  provisioner "file" {
    source      = "./actions-runner"
    destination = "/home/ubuntu/actions-runner"

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
      "ls -la /home/ubuntu/actions-runner",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/actions-runner",
      "ls -la /home/ubuntu/actions-runner/selfhost-runner.sh",
      "sudo chmod -x /home/ubuntu/actions-runner/selfhost-runner.sh",
      "ls -la /home/ubuntu/actions-runner/selfhost-runner.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.pem")
      host        = self.public_ip
    }
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

output "instance_ip" {
  value = aws_instance.runner-svr.public_ip
}