# Shared Storage for State Files

Run `terraform plan` to view the actions that will be taken by *main.ft*

Run `terraform apply` to apply those actions; This will create your s3 Bucket

Uncomment 
```
# terraform {
#   backend "s3" {
#     bucket  = "cool-app-state-yolo"
#     key     = "terraform.tfstate"
#     region  = "us-east-1"
#     encrypt = true
#   }
# }
```

Run `terraform plan` to view the new actions that will be taken by *main.ft*

Run `terraform apply` to apply those actions; This will store the *terraform.ftstate* file in your s3 Bucket

### Notes:

- You may need to run `terraform init` as your first step
- The `terraform {}` code is initially commented as the bucket needs to exist in order to be used to save your state file
