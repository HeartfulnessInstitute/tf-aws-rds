output "db_instance_identifier" {
value = aws_db_instance.this.identifier
}


output "db_instance_arn" {
value = aws_db_instance.this.arn
}


output "endpoint" {
value = aws_db_instance.this.endpoint
}


output "port" {
value = aws_db_instance.this.port
}


output "address" {
value = aws_db_instance.this.address
}


output "db_subnet_group_name" {
value = aws_db_subnet_group.this.name
}


output "vpc_security_group_ids_used" {
value = length(var.vpc_security_group_ids) > 0 ? var.vpc_security_group_ids : aws_security_group.default[*].id
}
