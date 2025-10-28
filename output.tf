output "db_instance_id" {
  description = "RDS instance resource id"
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "RDS endpoint address (hostname)"
  value       = aws_db_instance.this.endpoint
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.this.port
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}

output "db_subnet_ids" {
  description = "List of subnet IDs used for the DB subnet group"
  value       = local.db_subnet_ids_final
}

output "db_security_group_ids" {
  description = "List of security group IDs attached to the DB"
  value       = local.final_security_group_ids
}
