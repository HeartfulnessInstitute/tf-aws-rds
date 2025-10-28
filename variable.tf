variable "project_name" {
  description = "Project name (used to build resource names)"
  type        = string
}

variable "environment" {
  description = "Environment, e.g. dev/stage/prod"
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for names"
  type        = string
  default     = ""
}

# VPC / networking
variable "vpc_id" {
  description = "VPC ID to place RDS into. If empty, module expects caller to provide subnets via private_subnet_ids."
  type        = string
}

variable "private_subnet_ids" {
  description = <<EOT
Private subnet IDs to use for DB subnet group. Accepts:
- list(string) (recommended), OR
- map/object (e.g. module.vpc.private_subnet_ids) — module will convert values().
EOT
  type    = any
  default = []
}

variable "create_db_subnet_group" {
  description = "Whether the module should create an aws_db_subnet_group using private_subnet_ids"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  description = "If using an existing DB subnet group, provide its name. If create_db_subnet_group=true and this is set, it will be used as the created name."
  type        = string
  default     = ""
}

# Security / access
variable "ec2_security_group_ids" {
  description = "List of EC2 security group IDs that should be allowed to access the DB (by SG reference)."
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "Extra CIDR blocks allowed to access RDS (in addition to ec2_security_group_ids). Use sparingly."
  type        = list(string)
  default     = []
}

#############################
# RDS configuration
#############################

variable "identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "engine" {
  description = "Database engine (mysql, postgres, etc.)"
  type        = string
}

variable "engine_version" {
  description = "Database engine version (e.g. 8.0)"
  type        = string
  default     = ""
}

variable "instance_class" {
  description = "RDS instance class (e.g. db.t3.micro)"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage (GB)"
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage for autoscaling (if supported)"
  type        = number
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
}

variable "db_name" {
  description = "Initial database name (optional)"
  type        = string
  default     = ""
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password (sensitive)"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "DB port"
  type        = number
}

variable "parameter_group_name" {
  description = "Optional DB parameter group name"
  type        = string
  default     = ""
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "multi_az" {
  description = "Enable Multi-AZ"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Whether the DB should be publicly accessible"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy (true => skip)"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}
