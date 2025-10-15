locals {
  merged_tags = merge({ Service = "rds" }, var.tags)
  subnet_group_name = length(aws_db_subnet_group.this) > 0 ? aws_db_subnet_group.this[0].name : coalesce(var.db_subnet_group_name, "${var.db_identifier}-subnets")
}

# Security group for RDS
resource "aws_security_group" "this" {
  name        = "${var.db_identifier}-sg"
  description = "Security group for RDS ${var.db_identifier}"
  vpc_id      = var.vpc_id
  tags        = merge(local.merged_tags, { Name = "${var.db_identifier}-sg" })
}

# optional ingress rules from CIDR blocks
resource "aws_vpc_security_group_ingress_rule" "mysql_cidrs" {
  count             = length(var.allowed_cidr_blocks)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_cidr_blocks[count.index]
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  description       = "MySQL access from allowed CIDR"
}

# Create DB subnet group only when requested and subnets provided
resource "aws_db_subnet_group" "this" {
  count      = var.create_db_subnet_group && length(var.private_subnet_ids) > 0 ? 1 : 0
  name       = coalesce(var.db_subnet_group_name, "${var.db_identifier}-subnets")
  subnet_ids = var.private_subnet_ids
  tags       = merge(local.merged_tags, { Name = coalesce(var.db_subnet_group_name, "${var.db_identifier}-subnets") })
}

# Parameter group (optional)
resource "aws_db_parameter_group" "this" {
  name   = "${var.db_identifier}-pg"
  family = "mysql8.0"
  tags   = local.merged_tags
}

# RDS instance
resource "aws_db_instance" "this" {
  identifier             = var.db_identifier
  engine                 = var.db_engine
  engine_version         = var.db_engine_version

  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name

  allocated_storage      = var.db_allocated_storage
  max_allocated_storage  = var.db_max_allocated_storage

  storage_encrypted      = true
  publicly_accessible    = false
  multi_az               = var.multi_az

  vpc_security_group_ids = [aws_security_group.this.id]

  # safely reference subnet group name: if created above use that, otherwise use provided name
  db_subnet_group_name   = local.subnet_group_name

  parameter_group_name   = aws_db_parameter_group.this.name

  backup_retention_period = var.backup_retention_days
  backup_window           = "19:30-20:00"
  maintenance_window      = "sun:20:30-sun:21:30"
  auto_minor_version_upgrade = true

  deletion_protection    = var.deletion_protection
  skip_final_snapshot    = true
  apply_immediately      = var.apply_immediately

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  tags = local.merged_tags

  lifecycle {
    prevent_destroy = false
    # ignore password changes in TF lifecycle if you rotate externally (optional)
    ignore_changes  = [password]
  }
}
