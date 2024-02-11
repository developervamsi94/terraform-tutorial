output "server_public_ip" {
  description = "Server IP address"
  value = aws_instance.ec2_instance_1.public_ip
}