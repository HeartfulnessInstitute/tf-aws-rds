variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "db_identifier" {
  description = "RDS identifier"
  type        = string
}

variable "db_engine" {
  description = "RDS engine (e.g. mysql)"
  type        = string
}

variable "db_engine_version" {
  description = "RDS engine version (e.g. 8.0)"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class (e.g. db.t3.micro)"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage (GB)"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Max allocated storage (GB) for autoscaling"
  type        = number
  default     = 100
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the DB subnet group (min 2 across AZs). If empty and create_db_subnet_group=true, validation will fail."
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.private_subnet_ids) == 0 || length(var.private_subnet_ids) >= 2
    error_message = "When create_db_subnet_group = true, provide at least 2 private_subnet_ids in different AZs."
  }
}

variable "create_db_subnet_group" {
  description = "Whether to create a DB subnet group from private_subnet_ids"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  description = "If using an existing DB subnet group, provide its name (used when create_db_subnet_group = false). If create=true and name provided, that name will be used for creation."
  type        = string
  default     = null
}

variable "allowed_cidr_blocks" {
  description = "Optional CIDR blocks allowed to reach DB (use sparingly). Only applied when non-empty."
  type        = list(string)
  default     = []
}

variable "multi_az" {
  description = "Enable Multi-AZ"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

# Extra options you can expand later
variable "apply_immediately" {
  description = "Whether to apply changes immediately"
  type        = bool
  default     = false
}
