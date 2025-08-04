resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow MySQL access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-subnet-group"
  }
}


resource "aws_db_instance" "mysql" {
  identifier             = "${var.project_name}-db"
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.db_username
  password               = var.db_password
  port                   = 3306
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  multi_az               = var.multi_az

  tags = {
    Name = "${var.project_name}-rds"
  }
}

data "aws_caller_identity" "current" {}

/* resource "aws_kms_key" "rds_key" {
  description             = "KMS key for encrypting RDS and Secrets Manager secrets"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement: [
      {
        Sid       = "Enable IAM User Permissions",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action    = "kms:*",
        Resource  = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "rds_key_alias" {
  name          = "alias/hfncare-rds-key"
  target_key_id = aws_kms_key.rds_key.key_id
}*/


resource "aws_secretsmanager_secret" "db_secret" {
  name = "hfn/rds/db_credentials"
  kms_key_id  = "arn:aws:kms:ap-south-1:502390415551:key/7a13d2a9-02d8-42e1-b310-ffeaa286f995"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    db_username = var.db_username
    db_password = var.db_password
  })
}
