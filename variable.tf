variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
}

variable "engine" {
  description = "Database engine (mysql, postgres, mariadb, oracle-ee, sqlserver-ex)"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage for autoscaling in GB"
  type        = number
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
}

variable "kms_key_id" {
  description = "KMS key ID for encryption (optional)"
  type        = string
  default     = ""
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
}

variable "master_password" {
  description = "Master password for the database (use AWS Secrets Manager in production)"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
}

variable "publicly_accessible" {
  description = "Make database publicly accessible"
  type        = bool
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
}

variable "backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
}



variable "auto_minor_version_upgrade" {
  description = "Enable auto minor version upgrade"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to access the database"
  type        = list(string)
  default     = []
}

variable "parameter_group_family" {
  description = "Database parameter group family"
  type        = string
}

variable "parameters" {
  description = "Database parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
