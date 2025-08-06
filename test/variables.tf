variable "aws_region" {
  type    = string
  default = "ap-south-1"
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

variable "allocated_storage" {
     type = number 
}

variable "storage_type" { 
    type = string 
}

variable "engine_version" { 
    type = string 
}

variable "instance_class" {
     type = string
}

variable "db_username" { 
    type = string 
}

variable "skip_final_snapshot" {
     type = bool
}

variable "backup_retention_period" { 
    type = number 
}

variable "multi_az" {
     type = bool 
}
