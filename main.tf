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
}

############################################
# CREATE SUBNETS 
############################################
resource "aws_subnet" "created" {
  count = length(local.db_subnet_ids_input) == 0 && var.create_subnets ? length(var.subnet_cidrs) : 0

  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = length(var.availability_zones) > count.index ? var.availability_zones[count.index] : null

  tags = merge({
    Name = "${var.name}-db-subnet-${count.index}"
  }, var.subnet_tags)
}

# Final subnet list — prefer existing, fallback to created
locals {
  db_subnet_ids_final = length(local.db_subnet_ids_input) > 0 ? local.db_subnet_ids_input : aws_subnet.created[*].id
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
      error_message = "At least 2 subnets are required for RDS (across AZs)."
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
vpc_security_group_ids = (
  length(var.security_group_ids) > 0 ? var.security_group_ids :
  length(var.vpc_security_group_ids) > 0 ? var.vpc_security_group_ids :
  length(aws_security_group.default) > 0 ? aws_security_group.default[*].id :
  []
)

  skip_final_snapshot     = true
  apply_immediately       = false
  deletion_protection     = false

  parameter_group_name = var.parameter_group_name != "" ? var.parameter_group_name : null

  tags = var.tags
}
