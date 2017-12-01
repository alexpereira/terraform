output "elb_dns_name" {
    value = "${aws_elb.cluster-of-web-servers-ELB.dns_name}"
}
