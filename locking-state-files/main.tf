provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "new-cool-app-state" {
  bucket = "new-cool-app-state-yolo"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "new-cool-app-statelock" {
  name           = "new-cool-app-lock-table"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.new-cool-app-state.arn}"
}

# terraform {
#   backend "s3" {
#     bucket  = "new-cool-app-state-yolo"
#     key     = "terraform.tfstate"
#     region  = "us-east-1"
#     encrypt = true
#     dynamodb_table= "new-cool-app-lock-table"
#   }
# }
