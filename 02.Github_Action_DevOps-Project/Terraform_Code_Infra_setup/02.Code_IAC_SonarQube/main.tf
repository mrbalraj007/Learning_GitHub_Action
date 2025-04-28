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


resource "aws_instance" "sonar" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.sonar-VM-SG.id]
  user_data              = templatefile("./sonar_install.sh", {})

  tags = var.instance_tags

  root_block_device {
    volume_size = var.root_volume_size
  }

  # instance_market_options {
  #  market_type = "spot"
  #  spot_options {
  #    max_price = "0.0151" # Set your maximum price for the spot instance
  #  }
  # }
}

resource "aws_security_group" "sonar-VM-SG" {
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

# Remove this output as it's now in outputs.tf
# output "instance_ip" {
#   value = aws_instance.sonar.public_ip
# }