locals {
  # Try to convert db_subnet_ids to a list:
  # - If var.db_subnet_ids is a map/object, values(...) will succeed and return a list of IDs.
  # - If values(...) fails (e.g. because var.db_subnet_ids is already a list), the try() fallback returns var.db_subnet_ids.
  db_subnet_ids = try(values(var.db_subnet_ids), var.db_subnet_ids)
}

resource "aws_db_subnet_group" "this" {
  name       = var.subnet_group_name != "" ? var.subnet_group_name : "${var.name}-db-subnet-group"
  subnet_ids = local.db_subnet_ids

  tags = merge({
    Name = "${var.name}-db-subnet-group"
  }, var.tags)
}

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
  skip_final_snapshot     = true
  apply_immediately       = false
  deletion_protection     = false

  # only set parameter_group_name when provided (avoid passing empty string)
  parameter_group_name = var.parameter_group_name != "" ? var.parameter_group_name : null

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

