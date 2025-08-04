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


data "aws_secretsmanager_secret" "db_secret" {
  name = "hfn/rds/db_credentials"
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)
}

module "rds" {
  source = "./modules/rds-mysql"

  project_name           = var.project_name
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
  allowed_cidr_blocks    = var.allowed_cidr_blocks
  db_name     = var.db_name
  db_username = local.db_creds.db_username
  db_password = local.db_creds.db_password
  multi_az               = false
}

module "iam" {
  source = "./modules/iam"
}
