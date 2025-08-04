output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_sg.id
}

/*output "kms_key_arn" {
  value = aws_kms_key.rds_key.arn
}*/
