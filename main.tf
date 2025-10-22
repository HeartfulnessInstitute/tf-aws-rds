##############################
# Locals
##############################
locals {
  # Normalize db_subnet_ids to list (map or list input)
  db_subnet_ids = try(values(var.db_subnet_ids), var.db_subnet_ids)
}

##############################
# Subnet Group
##############################
resource "aws_db_subnet_group" "this" {
  name       = var.subnet_group_name != "" ? var.subnet_group_name : "${var.name}-db-subnet-group"
  subnet_ids = local.db_subnet_ids

  tags = merge({
    Name = "${var.name}-db-subnet-group"
  }, var.tags)
}

##############################
# DB Security Group
##############################
resource "aws_security_group" "db_sg" {
  name        = "${var.name_prefix}-db-sg"
  description = "Allow DB access"
  vpc_id      = var.vpc_id

  # Access from app SGs or specific CIDRs
  dynamic "ingress" {
    for_each = length(var.db_allowed_sg_ids) > 0 ? var.db_allowed_sg_ids : []
    content {
      description              = "Allow DB from app SG"
      from_port                = var.db_port
      to_port                  = var.db_port
      protocol                 = "tcp"
      security_groups          = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = length(var.db_allowed_cidrs) > 0 ? [1] : []
    content {
      description = "Allow DB from CIDRs"
      from_port   = var.db_port
      to_port     = var.db_port
      protocol    = "tcp"
      cidr_blocks = var.db_allowed_cidrs
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-db-sg" })
}

##############################
# RDS Instance
##############################
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
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  parameter_group_name = var.parameter_group_name != "" ? var.parameter_group_name : null

  tags = merge(var.tags, { Name = "${var.name}-rds" })

  lifecycle {
    create_before_destroy = true
  }
}
