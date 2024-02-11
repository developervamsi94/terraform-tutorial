terraform {

  backend "s3" {
    bucket = "vamsi-terraform-state-94"
    key = "data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform_lock_table"
    encrypt = true
  }

}

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "terraform_db" {
  instance_class = "db.t2.micro"
  engine = "mysql"
  db_name = var.db_name
  skip_final_snapshot = true
  allocated_storage = 10
  identifier_prefix = "terraform-up-and-running"

  username = var.db_username
  password = var.db_password

}