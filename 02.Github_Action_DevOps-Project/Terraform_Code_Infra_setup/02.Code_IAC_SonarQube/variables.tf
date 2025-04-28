# AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# AMI Configuration
variable "ami_filter_name" {
  description = "Filter name for AMI selection"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"
}

variable "ami_virtualization_type" {
  description = "Virtualization type for AMI"
  type        = string
  default     = "hvm"
}

variable "ami_owners" {
  description = "Owner ID for AMI filtering"
  type        = list(string)
  default     = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

# Instance Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "MYLABKEY"
}

variable "instance_tags" {
  description = "Tags to apply to the instance"
  type        = map(string)
  default = {
    Name = "SonarQube"
  }
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 25
}

# Security Group Configuration
variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "sonar-VM-SG"
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
  default     = "Allow inbound traffic"
}

variable "sg_ingress_ports" {
  description = "List of ingress ports to open"
  type        = list(number)
  default     = [25, 22, 80, 443, 6443, 465, 8080, 9000, 3000]
}

variable "sg_custom_port_range" {
  description = "Custom TCP port range"
  type        = map(number)
  default = {
    from_port = 2000
    to_port   = 11000
  }
}

variable "sg_cidr_blocks" {
  description = "CIDR blocks for security group rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
