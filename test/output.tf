output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_security_group_id" {
  description = "Security Group ID for RDS access"
  value       = module.rds.rds_sg_id
}
