provider "aws" {
    region = "us-east-1"
}

resource "aws_launch_configuration" "cluster-of-web-servers" {
    ami = "ami-40d28157"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    tags {
        Name = "cluster-of-web-servers"
    }

    user_data = <<-EOF
                #!/bin/bash
                echo "Welcome to my web page :)" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
                EOF

    lifecycle {
        create_before_destroy = true
    }
    # NOTE: the catch here is to set every dependent resource to `true` as well
}

resource "aws_security_group" "instance" {
    name = "cluster-of-we-servers-instance"

    ingress {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

variable "server_port" {
    description = "Port number the service will use for HTTP requests"
    default= 8080
}

resource "aws_autoscaling_group" "cluster-of-web-servers-ASG" {
    launch_configuration = "${aws_launch_configuration.cluster-of-web-servers.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]

    # NOTE: this lets the ELB know which instances to send requests to
    load_balancers = ["${aws_elb.cluster-of-web-servers-ELB.name}"]
    health_check = "ELB"

    min_size = 2
    max_size = 10

    tag {
        key = "Name"
        value = "cluster-of-web-servers-ASG"
        propagate_at_launch = true
    }
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "cluster-of-web-servers-ELB" {
    name = "cluster-of-web-servers-ELB"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    security_groups = ["${aws_security_group.elb.id}"]

    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = "${var.server_port}"
        instance_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        interval = 30
        target = "HTTP:${var.server_port}/"
    }
}

resource "aws_security_group" "elb" {
    name = "cluster-of-we-servers-elb"

    ingress {
        from_port = "${var.load_balancer_port}"
        to_port = "${var.load_balancer_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

variable "load_balancer_port" {
    description = "Port number the load balancer will use to route HTTP requests"
    default= 80
}

output "elb_dns_name" {
    value = "${aws_elb.cluster-of-web-servers-ELB.dns_name}"
}
