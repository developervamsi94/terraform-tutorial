output "db_address" {
  value = aws_db_instance.terraform_db.address
  description = "Mysql DB address"
}

output "db_port" {
  value = aws_db_instance.terraform_db.port
  description = "MySQL DB port"
}