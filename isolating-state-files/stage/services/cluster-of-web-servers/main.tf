provider "aws" {
    region = "us-east-1"
}

data "terraform_remote_state" "postgres-db" {
  backend = "s3"

  config {
    bucket = "isolating-state-files-yolo"
    key = "stage/data-stores/postgres/terraform.tfstate"
    region = "us-east-1"
  }
}

data "template_file" "cool-web-page" {
    template = "${file("cool-web-page.sh")}"

    vars {
        server_port = "${var.server_port}"
        db_address = "${data.terraform_remote_state.postgres-db.address}"
        db_port = "${data.terraform_remote_state.postgres-db.port}"
    }
}

resource "aws_launch_configuration" "cluster-of-web-servers" {
    image_id = "ami-40d28157"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.instance.id}"]

    user_data = "${data.template_file.cool-web-page.rendered}"

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

resource "aws_autoscaling_group" "cluster-of-web-servers-ASG" {
    launch_configuration = "${aws_launch_configuration.cluster-of-web-servers.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]

    # NOTE: this lets the ELB know which instances to send requests to
    load_balancers = ["${aws_elb.cluster-of-web-servers-ELB.name}"]
    health_check_type = "ELB"

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

terraform {
  backend "s3" {
    bucket  = "isolating-state-files-yolo"
    key     = "stage/services/cluster-of-web-servers/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table= "isolating-state-files-lock-table"
  }
}
