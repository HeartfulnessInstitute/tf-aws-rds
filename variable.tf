#############################
# RDS BASE CONFIG
#############################
variable "name" {
  description = "Base name for RDS resources (used as identifier prefix)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to RDS resources"
  type        = map(string)
  default     = {}
}

#############################
# NETWORKING
#############################
variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "db_subnet_ids" {
  description = "Existing subnet IDs for DB subnet group. Accepts list, map/object, or single string."
  type        = any
  default     = []
}

variable "create_subnets" {
  description = "If true and db_subnet_ids is empty, create new subnets using subnet_cidrs"
  type        = bool
  default     = false
}

variable "subnet_cidrs" {
  description = "CIDR blocks for new subnets (used when create_subnets = true)"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "AZs for new subnets (optional). If empty, AWS auto-selects."
  type        = list(string)
  default     = []
}

variable "subnet_tags" {
  description = "Tags for created subnets"
  type        = map(string)
  default     = {}
}

variable "subnet_group_name" {
  description = "Optional name for DB subnet group"
  type        = string
  default     = ""
}

#############################
# SECURITY GROUP
#############################
variable "create_security_group" {
  description = "Whether to create a new SG for RDS"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "CIDRs allowed to connect to the DB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of existing SG IDs to attach to RDS (merged with created SG if enabled)"
  type        = list(string)
  default     = []
}

#############################
# DATABASE CONFIGURATION
#############################
variable "engine" {
  description = "RDS engine type (mysql, postgres, etc.)"
  type        = string
}

variable "engine_version" {
  description = "RDS engine version"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class (e.g., db.t3.micro)"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage (GB)"
  type        = number
}

variable "storage_type" {
  description = "Storage type"
  type        = string
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = false
}

variable "username" {
  description = "Master DB username"
  type        = string
}

variable "password" {
  description = "Master DB password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = number
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible"
  type        = bool
  default     = false
}

#############################
# BACKUP & MAINTENANCE
#############################
variable "parameter_group_name" {
  description = "Optional DB parameter group name"
  type        = string
  default     = ""
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
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
  default     = "sun:05:00-sun:06:00"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying the DB"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply modifications immediately"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection for the DB"
  type        = bool
  default     = false
}
