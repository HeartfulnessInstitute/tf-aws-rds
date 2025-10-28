# If the caller didn't provide a security group, create one inside the provided VPC
resource "aws_security_group" "default" {
count = var.create_default_sg ? 1 : 0
name = "rds-${var.identifier}-${random_id.sg_suffix.hex}"
description = "RDS module generated SG"
vpc_id = var.vpc_id


dynamic "ingress" {
for_each = var.default_sg_ingress_cidrs
content {
description = "allow ingress"
from_port = var.port
to_port = var.port
protocol = "tcp"
cidr_blocks = [ingress.value]
}
}


tags = merge(
{
"Name" = "rds-${var.identifier}"
},
var.tags
)
}


resource "random_id" "sg_suffix" {
keepers = {
identifier = var.identifier
}
byte_length = 2
}


# DB subnet group using the existing subnets provided by caller
resource "aws_db_subnet_group" "this" {
name = var.db_subnet_group_name != "" ? var.db_subnet_group_name : "rds-subnet-group-${var.identifier}"
subnet_ids = var.subnet_ids
description = "RDS subnet group for ${var.identifier}"


tags = merge(
{
Name = "rds-subnet-group-${var.identifier}"
},
var.tags
)
}

# RDS instance
resource "aws_db_instance" "this" {
identifier = var.identifier
engine = var.engine
engine_version = var.engine_version
instance_class = var.instance_class
allocated_storage = var.allocated_storage
max_allocated_storage = var.max_allocated_storage
storage_type = var.storage_type
storage_encrypted = var.storage_encrypted
kms_key_id = var.kms_key_id
db_subnet_group_name = aws_db_subnet_group.this.name
vpc_security_group_ids = length(var.vpc_security_group_ids) > 0 ? var.vpc_security_group_ids : (aws_security_group.default[*].id)
username = var.username
password = var.password
name = var.db_name
multi_az = var.multi_az
publicly_accessible = var.publicly_accessible
skip_final_snapshot = var.skip_final_snapshot
final_snapshot_identifier = var.final_snapshot_identifier
apply_immediately = var.apply_immediately
backup_retention_period = var.backup_retention_period
deletion_protection = var.deletion_protection
performance_insights_enabled = var.performance_insights_enabled
performance_insights_kms_key_id = var.performance_insights_kms_key_id

tags = merge({ Name = var.identifier }, var.tags)
}

