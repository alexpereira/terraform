provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "single-web-server" {
    ami = "ami-40d28157"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    tags {
        Name = "single-web-server"
    }

    user_data = <<-EOF
                #!/bin/bash
                echo "Welcome to my web page :)" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
}

resource "aws_security_group" "instance" {
    name = "single-web-page-instance"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
