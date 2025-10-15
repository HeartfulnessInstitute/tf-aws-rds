output "db_instance_id" {
  value = aws_db_instance.this.id
}

output "db_instance_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  value = aws_db_instance.this.address
}

output "db_subnet_group_name" {
  value = local.subnet_group_name
}

output "db_security_group_id" {
  value = aws_security_group.this.id
}
