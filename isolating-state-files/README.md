# Isolating State Files

The process to get these resources up and running is a little more lenthy than the previous ones. For this one, you will: 

 - create the s3 Bucket and DynamoDB table where you can store and lock your *terraform.tfstate* files
 - create a database instance of PostGres in RDS so that you can reference its address and port in your web server cluster
 - and finally, create the web server cluster


## Creating your s3 Bucket and DynamoDB table

Run `cd global/s3/` to change directory to *global/s3/*

Run `terraform init` to initialize terraform

Run `terraform plan` to view the actions that will be taken by *main.ft*

Run `terraform apply` to apply those actions; This will create your s3 Bucket and DynamoDB table

Uncomment 
```
# terraform {
#   backend "s3" {
#     bucket  = "isolating-state-files-yolo"
#     key     = "global/s3/terraform.tfstate"
#     region  = "us-east-1"
#     encrypt = true
#     dynamodb_table= "isolating-state-files-lock-table"
#   }
# }
```

Run `terraform plan` to view the new actions that will be taken by *main.ft*

Run `terraform apply` to apply those actions; This will store the *terraform.ftstate* file in your s3 Bucket and use your DynamoDB table to lock and unlock your state file

### Notes:

- The `terraform {}` code is initially commented as the s3 bucket dynamodb table need to exist in order to be used to save and lock your state file
- Although the book suggests using [Terragrunt](https://github.com/gruntwork-io/terragrunt) to automatically create missing resources, I chose to just comment out `terraform {}` for the first run. Also, this code and steps are not exactly the same in the book as the *backends* feature wasn't out when the book was published. You can read more about how *backends* works [here](https://www.terraform.io/docs/backends/index.html)


## Creating your RDS PostGres Database

Run `cd ../../stage/data-stores/postgres/` to change directory to *stage/data-stores/postgres/*

Run `export TF_VAR_db_password="[your password]"` to expose a password when creating your postgres database

Run `terraform init` to initialize terraform (It may ask if you want to use the same s3 bucket you created in *global/s3/main.tf* - say **yes**) 

Run `terraform plan` to view the actions that will be taken by *main.ft*

Run `terraform apply` to apply those actions; This will create your postgres database in RDS


## Creating your web server cluster

Run `cd ../../stage/services/cluster-of-web-servers/` to change directory to *stage/services/cluster-of-web-servers/*

Run `terraform init` to initialize terraform

Run `terraform plan` to view the actions that will be taken by *main.ft*

Run `terraform apply` to apply those actions; This will create your Security Groups, Load Balancer, Autoscaling Group and two EC2 instances

Copy and paste the value returned from `elb_dns_name` in your browser to see the web page with the address and port of your postgres db



