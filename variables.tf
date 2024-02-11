variable server_port {
  description = "server port used for HTTP request"
  type = number
  default = 8080
}

output "server_public_ip" {
  description = "The public IP address of the web server"
  value = aws_instance.ec2_instance_1.public_ip
}
