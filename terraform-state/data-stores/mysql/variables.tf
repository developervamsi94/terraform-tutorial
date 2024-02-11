variable "bucket_name" {
  description = "Name of S3 bucket where terraform state is stored"
  type = string
  default = "vamsi-terraform-state-94"
}

variable "terraform_lock_table_name" {
  description = "DynamoDB table name used for locking state files"
  type = string
  default = "terraform_lock_table"
}

variable "db_name" {
  description = "RDB database name"
  type = string
  default = "terraformdb"
}

variable "db_username" {
  description = "DB user name"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "DB password"
  type = string
  sensitive = true
}

