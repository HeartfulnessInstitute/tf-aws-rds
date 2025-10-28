##########################
# Helpers / locals
##########################

# Convert private_subnet_ids to a list if caller passed an object/map (common for module outputs)
locals {
  private_subnet_ids_list = (
    var.private_subnet_ids == null || length(var.private_subnet_ids) == 0
  ) ? [] : (
    # if it's a map/object, values(...) will produce the list of ids; if already a list, keep it
    can(values(var.private_subnet_ids)) ? values(var.private_subnet_ids) : var.private_subnet_ids
  )

  # final vpc id must be provided either directly or implied by calling module
  vpc_id_final = var.vpc_id != "" ? var.vpc_id : null

resource_name_prefix = trim(var.name_prefix != "" ? "${var.name_prefix}-" : "", "-")

}

##########################
# Validation - need at least 2 private subnets when creating DB subnet group
##########################
resource "null_resource" "validate_subnets" {
  count = (var.create_db_subnet_group && length(local.private_subnet_ids_list) < 2) ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Error: create_db_subnet_group=true requires at least 2 private_subnet_ids' && exit 1"
  }
}

##########################
# Create DB Subnet Group (if requested)
##########################
resource "aws_db_subnet_group" "this" {
  count = var.create_db_subnet_group ? 1 : 0

  name       = var.db_subnet_group_name != "" ? var.db_subnet_group_name : "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = local.private_subnet_ids_list

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Project     = var.project_name
    Environment = var.environment
  }
}

##########################
# Security Group for RDS
##########################
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "RDS SG for ${var.project_name}-${var.environment}"
  vpc_id      = local.vpc_id_final

  # allow inbound from specified EC2 SGs
  dynamic "ingress" {
    for_each = length(var.ec2_security_group_ids) > 0 ? var.ec2_security_group_ids : []
    content {
      from_port       = var.port
      to_port         = var.port
      protocol        = "tcp"
      security_groups = [ingress.value]
      description     = "Allow EC2 SG ${ingress.value} to talk to DB"
    }
  }

  # allow inbound from allowed CIDR blocks
  dynamic "ingress" {
    for_each = length(var.allowed_cidr_blocks) > 0 ? var.allowed_cidr_blocks : []
    content {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "Allow ${ingress.value} to access DB"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

##########################
# RDS Instance
##########################

resource "aws_db_instance" "this" {
  identifier             = var.identifier
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = var.engine
  engine_version         = length(var.engine_version) > 0 ? var.engine_version : null
  instance_class         = var.instance_class
  db_name                = var.db_name != "" ? var.db_name : null
  username               = var.username
  password               = var.password
  port                   = var.port

  vpc_security_group_ids = [aws_security_group.rds.id]

  # choose db_subnet_group_name only if we created it (or caller supplied name and create_db_subnet_group=false)
  db_subnet_group_name = var.create_db_subnet_group ? aws_db_subnet_group.this[0].name : (var.db_subnet_group_name != "" ? var.db_subnet_group_name : null)

  backup_retention_period = var.backup_retention_days
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  apply_immediately = var.apply_immediately

  tags = {
    Name        = "${var.project_name}-${var.environment}-db"
    Project     = var.project_name
    Environment = var.environment
  }
}
