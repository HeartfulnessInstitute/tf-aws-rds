############################################
# VPC Configuration
############################################
variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "use_existing_vpc" {
  description = "Whether to use an existing VPC (enables data source lookup)"
  type        = bool
  default     = true
}

############################################
# Subnet Configuration
############################################
variable "db_subnet_ids" {
  description = "Existing subnet IDs for RDS (list, map, or string). If empty, subnets will be created."
  type        = any
  default     = []
}

variable "auto_discover_subnets" {
  description = "Automatically discover subnets in the VPC (used when db_subnet_ids is empty)"
  type        = bool
  default     = false
}

variable "subnet_filter_tags" {
  description = "Tags to filter subnets when auto-discovering (e.g., {Tier = 'private'})"
  type        = map(string)
  default     = null
}

variable "create_subnets" {
  description = "Create new subnets if db_subnet_ids is empty"
  type        = bool
  default     = false
}

variable "subnet_cidrs" {
  description = "CIDR blocks for new subnets (only used if create_subnets = true)"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "Availability zones for new subnets"
  type        = list(string)
  default     = []
}

variable "subnet_tags" {
  description = "Additional tags for created subnets"
  type        = map(string)
  default     = {}
}

variable "subnet_group_name" {
  description = "Name for DB subnet group (defaults to {name}-db-subnet-group)"
  type        = string
  default     = ""
}

############################################
# RDS Configuration
############################################
variable "name" {
  description = "Name/identifier for the RDS instance"
  type        = string
}

variable "engine" {
  description = "Database engine (postgres, mysql, mariadb, etc.)"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "RDS instance type (e.g., db.t3.micro)"
  type        = string
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
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

variable "security_group_ids" {
  description = "VPC security group IDs"
  type        = list(string)
}

variable "parameter_group_name" {
  description = "DB parameter group name"
  type        = string
  default     = ""
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = true
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

############################################
# Tags
############################################
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
