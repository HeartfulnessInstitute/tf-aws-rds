variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "allowed_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "db_name" {
  type = string
  sensitive   = true
}

variable "db_username" {
  type = string
  sensitive   = true
}

variable "db_password" {
  type      = string
  sensitive = true
}
