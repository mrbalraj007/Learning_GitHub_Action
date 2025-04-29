# Fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_filter_name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.ami_virtualization_type]
  }

  owners = var.ami_owners
}


resource "aws_instance" "runner-svr" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.runner-VM-SG.id]
  user_data              = templatefile("./runner_install.sh", {})

  tags = var.instance_tags

  root_block_device {
    volume_size = var.root_volume_size
  }

  # Copy the actions-runner folder after the instance is created
  provisioner "file" {
    source      = "./actions-runner"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  # Set appropriate ownership for the copied folder
  provisioner "remote-exec" {
    inline = [
      "ls -la /home/ubuntu/actions-runner",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/actions-runner"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "runner-VM-SG" {
  name        = var.sg_name
  description = var.sg_description

  dynamic "ingress" {
    for_each = toset(var.sg_ingress_ports)
    content {
      description = "inbound rule for port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.sg_cidr_blocks
    }
  }

  ingress {
    description = "Custom TCP Port Range"
    from_port   = var.sg_custom_port_range.from_port
    to_port     = var.sg_custom_port_range.to_port
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_cidr_blocks
  }

  tags = {
    Name = "${var.sg_name}"
  }
}
