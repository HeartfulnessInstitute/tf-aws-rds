variable "name" {
  description = "Name/identifier of the DB instance"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g. postgres, mysql)"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "Instance type (e.g. db.t3.micro)"
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

variable "username" {
  description = "DB admin username"
  type        = string
}

variable "password" {
  description = "DB admin password"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Whether to enable multi-AZ deployment"
  type        = bool
}

variable "publicly_accessible" {
  description = "Whether the DB should be publicly accessible"
  type        = bool
}

variable "vpc_id" {
  description = "VPC ID for the DB security group"
  type        = string
}

variable "db_port" {
  description = "DB port"
  type        = number
}

variable "db_subnet_ids" {
  description = "Subnets where the DB instance should reside"
  type        = any
}

variable "db_allowed_sg_ids" {
  description = "List of SG IDs allowed to access the DB"
  type        = list(string)
  default     = []
}

variable "db_allowed_cidrs" {
  description = "List of CIDRs allowed to access the DB"
  type        = list(string)
  default     = []
}

variable "parameter_group_name" {
  description = "Optional DB parameter group name"
  type        = string
  default     = ""
}

variable "subnet_group_name" {
  description = "Optional custom name for DB subnet group"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
