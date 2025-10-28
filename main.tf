############################################
# LOCALS: Normalize and fallback logic
############################################
locals {
  # Normalize input subnet IDs — supports list, map, or single string
  db_subnet_ids_input = (
    can(tolist(var.db_subnet_ids)) ? tolist(var.db_subnet_ids) :
    can(values(var.db_subnet_ids)) ? values(var.db_subnet_ids) :
    var.db_subnet_ids == "" || var.db_subnet_ids == null ? [] :
    [var.db_subnet_ids]
  )
  
  # Use existing subnets if provided, otherwise create new ones
  db_subnet_ids_final = length(local.db_subnet_ids_input) > 0 ? local.db_subnet_ids_input : aws_subnet.created[*].id
}

############################################
# DATA SOURCES: Fetch existing VPC and Subnets
############################################
data "aws_vpc" "existing" {
  count = var.use_existing_vpc ? 1 : 0
  id    = var.vpc_id
}

data "aws_subnets" "existing" {
  count = var.use_existing_vpc && var.auto_discover_subnets ? 1 : 0
}
  
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
############################################
# DB Subnet Group
############################################
resource "aws_db_subnet_group" "this" {
  name       = var.subnet_group_name != "" ? var.subnet_group_name : "${var.name}-db-subnet-group"
  subnet_ids = local.db_subnet_ids_final
  
  tags = merge({
    Name = "${var.name}-db-subnet-group"
  }, var.tags)
  
  lifecycle {
    precondition {
      condition     = length(local.db_subnet_ids_final) >= 2
      error_message = "At least 2 subnets are required for RDS (must span at least 2 availability zones)."
    }
  }
}

############################################
# RDS Instance
############################################
resource "aws_db_instance" "this" {
  identifier              = var.name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  vpc_security_group_ids  = var.security_group_ids
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  apply_immediately       = var.apply_immediately
  deletion_protection     = var.deletion_protection
  parameter_group_name    = var.parameter_group_name != "" ? var.parameter_group_name : null
  
  tags = merge({
    Name = var.name
  }, var.tags)
}
