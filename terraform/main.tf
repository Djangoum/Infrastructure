terraform {
    backend "s3" {
        bucket         = "lists-infrastructure-terraform-state"
        key            = "global/s3/terraform.tfstate"
        region         = "eu-west-3"
    }
}

locals {
    appversion = "001"
    db_server_name = "listsdb${terraform.workspace}${local.appversion}"
}

provider "aws" {
    profile = "default"
    region = "eu-west-3"
}

resource "aws_db_instance" "lists_database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = local.db_server_name
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}