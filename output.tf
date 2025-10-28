output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_security_group_id" {
  description = "DB security group id created or provided (first found)"
  value = (
    length(aws_security_group.default) > 0 ? aws_security_group.default[0].id :
    (length(var.security_group_ids) > 0 ? var.security_group_ids[0] :
      (length(var.vpc_security_group_ids) > 0 ? var.vpc_security_group_ids[0] : null))
  )
}


output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.this.name
}
