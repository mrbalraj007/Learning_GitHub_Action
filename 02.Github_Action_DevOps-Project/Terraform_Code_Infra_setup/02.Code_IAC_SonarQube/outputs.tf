# Instance information outputs
output "instance_name" {
  description = "Name of the EC2 instance"
  value       = aws_instance.sonar.tags.Name
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.sonar.private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.sonar.public_ip
}

output "sonarqube_url" {
  description = "URL to access SonarQube"
  value       = "http://${aws_instance.sonar.public_ip}:9000"
}

output "ssh_connection_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.sonar.public_ip}"
}
