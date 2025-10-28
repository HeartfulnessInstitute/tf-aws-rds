########################################
# Normalize db_subnet_ids into list(string)
########################################
locals {
  db_subnet_ids_final = length(local.db_subnet_ids) > 0 ? local.db_subnet_ids : (
    length(try(aws_subnet.created, [])) > 0 ? aws_subnet.created[*].id : []
  )
}



########################################
# Security Group 
########################################
resource "aws_security_group" "db_sg" {
  count = var.create_security_group ? 1 : 0

  name_prefix = "${var.name}-db-sg-"
  description = "Security group for ${var.name} RDS instance"
  vpc_id      = var.vpc_id

  tags = merge({
    Name = "${var.name}-db-sg"
  }, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "db_ingress" {
  count = var.create_security_group ? length(var.allowed_cidr_blocks) : 0

  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.db_sg[0].id
  description       = "Allow database access from specified CIDR blocks"
}

resource "aws_security_group_rule" "db_egress" {
  count = var.create_security_group ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_sg[0].id
  description       = "Allow all outbound traffic"
}

# Combine provided security groups with created SG (if any)
locals {
  final_security_group_ids = concat(
    var.security_group_ids,
    var.create_security_group ? (length(aws_security_group.db_sg) > 0 ? [aws_security_group.db_sg[0].id] : []) : []
  )
}

########################################
# DB Subnet Group (uses db_subnet_ids_final)
########################################
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

########################################
# RDS Instance
########################################
resource "aws_db_instance" "this" {
  identifier             = var.name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  storage_encrypted      = var.storage_encrypted

  username = var.username
  password = var.password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = local.final_security_group_ids
  publicly_accessible    = var.publicly_accessible

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  apply_immediately    = var.apply_immediately
  deletion_protection  = var.deletion_protection
  parameter_group_name = var.parameter_group_name != "" ? var.parameter_group_name : null

  port = var.db_port

  tags = var.tags

  depends_on = [aws_db_subnet_group.this]
}
