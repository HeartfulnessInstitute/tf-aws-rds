variable "name" {
  description = "Name prefix for the RDS resources"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g., postgres, mysql, mariadb)"
  type        = string
}

variable "engine_version" {
  description = "Version of the database engine"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class (e.g., db.t3.micro, db.t3.medium)"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1, etc.)"
  type        = string
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
}

variable "publicly_accessible" {
  description = "Whether the DB should be publicly accessible"
  type        = bool
}

variable "vpc_id" {
  description = "VPC ID where the RDS instance will be deployed"
  type        = string
  default     = ""
}

variable "db_subnet_ids" {
  description = "List or map of DB subnet IDs (some VPC modules output an object)"
  type        = any
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the RDS instance"
  type        = list(string)
  default     = []
}

variable "username" {
  description = "Master username for the RDS instance"
  type        = string
}

variable "password" {
  description = "Master password for the RDS instance (keep it secret)"
  type        = string
  sensitive   = true
}

variable "parameter_group_name" {
  description = "Custom DB parameter group name (optional)"
  type        = string
  default     = ""
}

variable "subnet_group_name" {
  description = "Optional custom name for the DB subnet group"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default     = {}
}

