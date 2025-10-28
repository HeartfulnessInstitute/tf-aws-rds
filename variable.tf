########################################
# REQUIRED VARIABLES
########################################
variable "name" {
  description = "Name identifier for the RDS instance"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "db_subnet_ids" {
  description = "List of existing subnet IDs for RDS (can be list, map, or string)"
  type        = any
}

variable "username" {
  description = "Master username for the database"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

########################################
# VARIABLES
########################################
variable "engine" {
  description = "Database engine (e.g., postgres, mysql)"
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

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Make RDS publicly accessible"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
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

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "parameter_group_name" {
  description = "Custom parameter group name"
  type        = string
  default     = ""
}

variable "subnet_group_name" {
  description = "Custom subnet group name"
  type        = string
  default     = ""
}

########################################
# SECURITY GROUP VARIABLES
########################################
variable "create_security_group" {
  description = "Create a security group for RDS"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "Additional security group IDs to attach"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the database"
  type        = list(string)
  default     = []
}

variable "db_port" {
  description = "Database port"
  type        = number
}
variable "tags" {
  description = "A map of tags to assign to RDS resources"
  type        = map(string)
  default     = {}
}
