output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.main.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.main.arn
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "RDS instance address"
  value       = aws_db_instance.main.address
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

output "db_instance_name" {
  description = "RDS database name"
  value       = aws_db_instance.main.db_name
}

output "db_master_username" {
  description = "RDS master username"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "db_security_group_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds.id
}

output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.main.name
}

output "db_parameter_group_name" {
  description = "DB parameter group name"
  value       = aws_db_parameter_group.main.name
}

output "secrets_manager_secret_arn" {
  description = "ARN of Secrets Manager secret containing DB credentials"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "replica_instance_id" {
  description = "Read replica instance ID"
  value       = var.create_read_replica ? aws_db_instance.replica[0].id : null
}

output "replica_instance_endpoint" {
  description = "Read replica endpoint"
  value       = var.create_read_replica ? aws_db_instance.replica[0].endpoint : null
}
