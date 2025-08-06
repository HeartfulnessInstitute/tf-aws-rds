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
  region = var.aws_region
}


data "aws_caller_identity" "current" {}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?/"
}

resource "aws_kms_key" "rds_key" {
  description             = "KMS key for RDS & Secrets Manager encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      {
        Sid      = "Enable IAM User Permissions",
        Effect   = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "rds_key_alias" {
  name          = "alias/care-rds-secrets-key"
  target_key_id = aws_kms_key.rds_key.key_id
}

resource "aws_secretsmanager_secret" "db_secret" {
  name       = "hfncare/rds/db_credentials"
  kms_key_id = aws_kms_key.rds_key.arn
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    db_username = var.db_username
    db_password = random_password.db_password.result
  })
}

data "aws_secretsmanager_secret" "db_secret" {
  name = aws_secretsmanager_secret.db_secret.name
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)
}

module "rds" {
  source                  = "./modules/rds-mysql"
  project_name            = var.project_name
  vpc_id                  = var.vpc_id
  subnet_ids              = var.subnet_ids
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_name                 = var.db_name
  db_username             = local.db_creds.db_username
  db_password             = local.db_creds.db_password
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
}


module "iam" {
  source = "./modules/iam"
}
