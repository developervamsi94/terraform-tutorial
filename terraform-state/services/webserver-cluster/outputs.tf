output "server_dns_name" {
  description = "The public IP address of the web server"
  value = aws_lb.terraform_lb.dns_name
}