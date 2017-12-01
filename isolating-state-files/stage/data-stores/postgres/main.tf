provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "postgres-db" {
    engine = "postgres"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    name = "postgres_database"
    username = "birdperson"
    password = "${var.db_password}"
    skip_final_snapshot = true
}

terraform {
  backend "s3" {
    bucket  = "isolating-state-files-yolo"
    key     = "stage/data-stores/postgres/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table= "isolating-state-files-lock-table"
  }
}
