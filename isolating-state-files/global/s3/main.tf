provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "isolating-state-files" {
  bucket = "isolating-state-files-yolo"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "isolating-state-files-lock" {
  name           = "isolating-state-files-lock-table"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket  = "isolating-state-files-yolo"
    key     = "global/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table= "isolating-state-files-lock-table"
  }
}
