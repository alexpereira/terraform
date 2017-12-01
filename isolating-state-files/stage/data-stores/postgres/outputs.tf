output "address" {
  value = "${aws_db_instance.postgres-db.address}"
}

output "port" {
  value = "${aws_db_instance.postgres-db.port}"
}
