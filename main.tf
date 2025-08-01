terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region = var.region
}

module "rds" {
  source = "./modules/rds-mysql"

  project_name           = var.project_name
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
  allowed_cidr_blocks    = var.allowed_cidr_blocks
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  publicly_accessible    = false
  multi_az               = false
}
