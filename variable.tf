variable "identifier" {
  description = "Unique identifier for the RDS instance"
  type        = string
}

variable "engine" {
  description = "RDS engine (e.g. postgres, mysql)"
  type        = string
}

variable "engine_version" {
  description = "Engine version (optional)"
  type        = string
}

variable "instance_class" {
  description = "Instance size/class"
  type        = string
}

variable "allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
}

variable "max_allocated_storage" {
  description = "Autoscaling max storage (set 0 to disable)"
  type        = number
}

variable "storage_type" {
  description = "gp2, gp3, io1"
  type        = string
}

variable "storage_encrypted" {
  description = "Whether to encrypt storage"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "KMS key id for encryption (optional)"
  type        = string
  default     = ""
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

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "Existing VPC ID to attach resources to"
  type        = string
}

variable "subnet_ids" {
  description = "List of existing subnet ids to be used by the DB subnet group"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Optional list of existing security group ids. If omitted, module will create one."
  type        = list(string)
  default     = []
}

variable "create_default_sg" {
  description = "Create a default SG when vpc_security_group_ids not provided"
  type        = bool
  default     = true
}

variable "default_sg_ingress_cidrs" {
  description = "List of CIDR ranges allowed into the default SG (if created)"
  type        = list(string)
}

variable "port" {
  description = "DB port"
  type        = number
}

variable "db_subnet_group_name" {
  description = "Optional name for the DB subnet group"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to resources"
  type        = map(string)
  default     = {}
}

variable "multi_az" {
  description = "Enable Multi-AZ for RDS"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Whether DB should be publicly accessible"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "If skip_final_snapshot=false, provide a final snapshot id"
  type        = string
  default     = ""
}

variable "apply_immediately" {
  description = "Apply modifications immediately"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Prevent accidental deletion"
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "KMS key id for performance insights (optional)"
  type        = string
  default     = ""
}

variable "create_parameter_group" {
  type    = bool
  default = false
}

variable "parameter_group_family" {
  description = "Parameter group family (e.g. postgres12)"
  type        = string
  default     = ""
}

variable "parameter_group_parameters" {
  description = "Map of parameter name => value for the parameter group"
  type        = map(string)
  default     = {}
}

variable "parameter_group_name" {
  description = "Optional external parameter group name to use instead of creating one"
  type        = string
  default     = ""
}

# NOTE: keep this variable for your documentation, but avoid using it inside lifecycle.prevent_destroy
variable "prevent_destroy" {
  description = "Documentation-only: intended to signal that the consumer wants protection. DO NOT use directly in lifecycle.prevent_destroy."
  type        = bool
  default     = false
}
