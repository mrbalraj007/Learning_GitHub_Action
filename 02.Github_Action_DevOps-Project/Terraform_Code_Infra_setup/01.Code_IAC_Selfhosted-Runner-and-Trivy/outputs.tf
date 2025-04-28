# Instance information outputs
output "instance_name" {
  description = "Name of the EC2 instance"
  value       = aws_instance.runner-svr.tags.Name
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.runner-svr.private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.runner-svr.public_ip
}

output "ssh_connection_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.runner-svr.public_ip}"
}
