# Locking State Files

Run `terraform plan` to view the actions that will be taken by *main.ft*

Run `terraform apply` to apply those actions; This will create your s3 Bucket and DynamoDB table

Uncomment 
```
# terraform {
#   backend "s3" {
#     bucket  = "new-cool-app-state-yolo"
#     key     = "terraform.tfstate"
#     region  = "us-east-1"
#     encrypt = true
#     dynamodb_table= "new-cool-app-lock-table"
#   }
# }
```

Run `terraform plan` to view the new actions that will be taken by *main.ft*

Run `terraform apply` to apply those actions; This will store the *terraform.ftstate* file in your s3 Bucket and use your DynamoDB table to lock and unlock your state file

### Notes:

- You may need to run `terraform init` as your first step
- The `terraform {}` code is initially commented as the s3 bucket dynamodb table need to exist in order to be used to save and lock your state file
- Although the book suggests using [Terragrunt](https://github.com/gruntwork-io/terragrunt) to automatically create missing resources, I chose to just comment out `terraform {}` for the first run. Also, this code and steps are not exactly the same in the book as the *backends* feature wasn't out when the book was published. You can read more about how *backends* works [here](https://www.terraform.io/docs/backends/index.html)
