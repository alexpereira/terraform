provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cool-app-state" {
  bucket = "cool-app-state-yolo"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

terraform {
  backend "s3" {
    bucket  = "cool-app-state-yolo"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.cool-app-state.arn}"
}
