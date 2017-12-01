# Deploy a Single Web Server

Run `terraform plan` to view the actions that will be taken by *main.ft*

Run `terraform apply` to apply those actions; This will output the pulblic dns address of your load balancer

Run `curl http://[elb_dns]` to view the web server's response

You can also visit this response on your browser by going to your pulblic dns address
