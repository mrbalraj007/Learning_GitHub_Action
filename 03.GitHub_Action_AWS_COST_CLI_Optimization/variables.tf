# DEFINE DEFAULT VARIABLES HERE

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "key_name" {
  description = "Key Pair"
  type        = string
}

variable "volume_size" {
  description = "Volume size"
  type        = string
}

variable "region_name" {
  description = "AWS Region"
  type        = string
}

variable "server_name" {
  description = "EC2 Server Name"
  type        = string
}

variable "market_type" {
  description = "Volume size"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}

variable "aws_default_region" {
  description = "Default AWS Region"
  type        = string
}