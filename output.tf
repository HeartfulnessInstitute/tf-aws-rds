output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "rds_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.this.arn
}

output "subnet_group_name" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.this.name
}
