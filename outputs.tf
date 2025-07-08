output "instance_id" {
  description = "ID of the instance"
  value       = aws_db_instance.postgresql.*.id
}

output "identifier" {
  description = "ID of the RDS instance"
  value = element(concat("${aws_db_instance.postgresql.*.identifier}", [""]), 0)
}

output "instance_address" {
#  value       = aws_db_instance.postgresql.*.address
  value = "${element(concat("${aws_db_instance.postgresql.*.address}", [""]), 0)}"
  description = "Address of the instance"
}

output "instance_endpoint" {
 # value       = aws_db_instance.postgresql.*.endpoint
  value       = "${element(concat("${aws_db_instance.postgresql.*.endpoint}", [""]), 0)}"
  description = "DNS Endpoint of the instance"
}

output "instance_arn" {
  value       = aws_db_instance.postgresql.*.arn
  description = "The ARN of the RDS instance"
}

output "instance_name" {
#  value       = aws_db_instance.postgresql.*.db_name
  value = "${element(concat("${aws_db_instance.postgresql.*.db_name}", [""]), 0)}"
  description = "The Name of the RDS instance"
}

output "instance_status" {
  value       = aws_db_instance.postgresql.*.status
  description = "The RDS instance status"
}

output "instance_port" {
  value       = aws_db_instance.postgresql.*.port
  description = "The database port"
}

output "instance_maintenance_window" {
  value       = aws_db_instance.postgresql.*.maintenance_window
  description = "The RDS instance maintenance window time"
}

output "instance_backup" {
  value       = aws_db_instance.postgresql.*.backup_window
  description = "The RDS instance backup window time"
}

output "allocated_storage" {
  description = "The amount of allocated storage."
  value       = aws_db_instance.postgresql.*.allocated_storage
}

output "availability_zone" {
  description = "The availability zone of the instance."
  value       = aws_db_instance.postgresql.*.availability_zone
}

output "hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)."
  value       = aws_db_instance.postgresql.*.hosted_zone_id
}

output "instance_class" {
  description = "The RDS instance class."
  value       = aws_db_instance.postgresql.*.instance_class
}

output "resource_id" {
  description = "The RDS Resource ID of this instance."
  value       = aws_db_instance.postgresql.*.resource_id
}

output "username" {
  description = "The master username for the database."
  value       = aws_db_instance.postgresql.*.username
}

output "parameter_group_id" {
  description = "The db parameter group name."
  value       = aws_db_parameter_group.parameter_group.*.id
}

output "result" {
  value       = random_password.password.result
  description = "(String, Sensitive) The generated random string"
}

output "final_snapshot_identifier" {
  value = aws_db_instance.postgresql.*.final_snapshot_identifier
  description = "Final Snapshot Identifier of the Instance"
}

output "postgresql-log-group-arn" {
  value       = aws_cloudwatch_log_group.rds-postgresql.*.arn
  description = "Postgresql cloudwatch log group arn"
}

output "upgrade-log-group-arn" {
  value       = aws_cloudwatch_log_group.rds-upgrade.*.arn
  description = "Upgrade cloudwatch log group arn"
}

output "postscript-loggroup-name" {
  value = try(aws_cloudwatch_log_group.rds-postscripts[0].name, null)
}
