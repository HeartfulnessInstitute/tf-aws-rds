output "db_instance_id" {
  description = "RDS instance id"
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.this.port
}

output "db_subnet_group_name" {
  description = "DB subnet group name (if created)"
  value       = var.create_db_subnet_group ? aws_db_subnet_group.this[0].name : var.db_subnet_group_name
}

output "rds_security_group_id" {
  description = "Security group ID created for RDS"
  value       = aws_security_group.rds.id
}
