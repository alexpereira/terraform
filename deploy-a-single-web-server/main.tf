provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "single-web-server" {
    ami = "ami-40d28157"
    instance_type = "t2.micro"

    tags {
        Name = "single-web-server"
    }

    user_data = <<-EOF
                #!/bin/bash
                echo "Welcome to my web page :)" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
}
