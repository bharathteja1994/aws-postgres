locals {
  sec_group_tag = {
    "Name" = "rtlh-SecurityGroup"
  }
}

resource "aws_cloudwatch_log_group" "rds-postgresql" {
  count             = var.instance_count
  name              = "/aws/rds/instance/${var.instance_count > 1 ? replace(local.name, "-${var.identifier}", "-0${count.index + 1}") : local.name}/postgresql"
  retention_in_days = var.retention_in_days_rds_postgresql
  kms_key_id        = var.kms_key_id_log_group
  skip_destroy      = false
  tags              = merge(var.tags, local.tags_db)
}

resource "aws_cloudwatch_log_group" "rds-upgrade" {
  count             = var.instance_count
  name              = "/aws/rds/instance/${var.instance_count > 1 ? replace(local.name, "-${var.identifier}", "-0${count.index + 1}") : local.name}/upgrade"
  retention_in_days = var.retention_in_days_rds_upgrade
  kms_key_id        = var.kms_key_id_log_group
  skip_destroy      = false
  tags              = merge(var.tags, local.tags_db)
}

resource "aws_cloudwatch_log_group" "rds-postscripts" {
  count             = var.create_postscript_log_group ? 1 : 0
  name              = "/aws/rds/instance/${aws_db_instance.postgresql[0].identifier}/postscript"
  retention_in_days = var.retention_in_days_rds_postscript
  kms_key_id        = var.kms_key_id_log_group
  skip_destroy      = false
  tags              = merge(var.tags, local.tags_db)
}

resource "aws_db_instance" "postgresql" {
  depends_on = [
    aws_cloudwatch_log_group.rds-postgresql,
    aws_cloudwatch_log_group.rds-upgrade
  ]
  count                                 = var.instance_count
  identifier                            = var.instance_count > 1 ? replace(local.name, "-${var.identifier}", "-0${count.index + 1}") : local.name
  engine                                = var.read_replica || var.cross_region ? null : var.engine
  engine_version                        = var.read_replica || var.cross_region ? null : var.engine_version
  instance_class                        = var.instance_class
  allocated_storage                     = var.read_replica ? null : var.allocated_storage
  max_allocated_storage                 = var.read_replica ? null : var.max_allocated_storage
  storage_type                          = var.storage_type
  storage_encrypted                     = true
  kms_key_id                            = var.kms_key_id
  ca_cert_identifier                    = var.ca_cert_identifier
  db_name                               = var.restore_to_point_in_time == null ? var.read_replica || var.cross_region ? null : replace(local.dbn, "-", "") : null
  username                              = var.read_replica || var.cross_region ? null : "rtlhsysdba"
  password                              = var.read_replica || var.cross_region ? null : resource.random_password.password.result
  port                                  = var.port
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  replicate_source_db                   = var.replicate_source_db
  snapshot_identifier                   = var.snapshot_identifier
  vpc_security_group_ids                = concat([aws_security_group.this.id], var.vpc_security_group_ids)
  parameter_group_name                  = aws_db_parameter_group.parameter_group.id
  db_subnet_group_name                  = var.read_replica ? null : aws_db_subnet_group.default[0].name
  availability_zone                     = var.availability_zone
  multi_az                              = var.multi_az
  iops                                  = var.storage_type == "io1" ? var.iops : null
  publicly_accessible                   = false
  monitoring_role_arn                   = var.monitoring_role_arn
  monitoring_interval                   = var.monitoring_interval
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  maintenance_window                    = var.maintenance_window
  skip_final_snapshot                   = var.skip_final_snapshot
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  final_snapshot_identifier             = var.skip_final_snapshot == false ? "Final-snapshot-${var.instance_count > 1 ? replace(local.name, "-${var.identifier}", "-0${count.index + 1}") : local.name}" : var.final_snapshot_identifier
  backup_retention_period               = var.read_replica ? null : var.backup_retention_period
  backup_window                         = var.read_replica ? null : var.backup_window
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  deletion_protection                   = var.deletion_protection
  dedicated_log_volume                  = var.dedicated_log_volume
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  delete_automated_backups              = var.delete_automated_backups

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? var.restore_to_point_in_time : []
    content {
      restore_time                  = lookup(restore_to_point_in_time.value, "restore_time", null)
      source_db_instance_identifier = lookup(restore_to_point_in_time.value, "source_db_instance_identifier", null)
      source_dbi_resource_id        = lookup(restore_to_point_in_time.value, "source_dbi_resource_id", null)
      use_latest_restorable_time    = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", null)
    }
  }


  timeouts {
    create = var.db_instance_creation_timeout
  }
  tags = merge(var.tags, local.tags_db,{"database-platform-name" = var.instance_count > 1 ? replace(local.name, "-${var.identifier}", "-0${count.index + 1}") : local.name})
  lifecycle {
    ignore_changes = [allocated_storage, db_name, engine_version, instance_class, max_allocated_storage, kms_key_id, username, password, tags["db-patch-time-window"], tags["db-patch-schedule"], tags["prepatch-snapshot-flag"], tags["created-by"]]
  }
}

resource "aws_db_instance_role_association" "postgresql" {
  count                  = var.aws_db_instance_role_association ? 1 : 0
  db_instance_identifier = resource.aws_db_instance.postgresql[0].identifier
  feature_name           = var.feature_name
  role_arn               = var.role_arn
}

locals {
  json = jsondecode(
    file(
      var.postgresql_parameter_option_group
    ),
  )
}

resource "aws_db_parameter_group" "parameter_group" {
  name        = "rtlhdbpg-${local.name}"
  description = "rtlh DB Parameter Group for ${local.name}"
  family      = var.family

  dynamic "parameter" {
    for_each = local.json.parameter_group_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = merge(var.tags, local.tags_db)
  lifecycle {
    ignore_changes = [family, tags["db-patch-time-window"], tags["db-patch-schedule"], tags["prepatch-snapshot-flag"]]
  }

}

resource "aws_db_subnet_group" "default" {
  count       = var.read_replica ? 0 : 1
  name        = "rtlhdbsn-${local.name}"
  subnet_ids  = local.filtered_subnet_ids
  description = "rtlh DB Subnet group for ${local.name}"

  tags = merge(var.tags, local.tags_db)
  lifecycle {
    ignore_changes = [subnet_ids, tags["db-patch-time-window"], tags["db-patch-schedule"], tags["prepatch-snapshot-flag"]]
  }
}

data "aws_vpc" "vpc" {
   id = var.vpc_id
   filter {
     name   = "tag:Name"
     values = ["aws-landing-zone-VPC", "lz-additional-vpc-VPC"]
   }
 }

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id == null ? "${data.aws_vpc.vpc.id}" : var.vpc_id]

  }

  tags = {
    Network = "Private"
  }
}

data "aws_subnet" "selected" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id = each.value
 }

locals {
  filtered_subnet_ids = [
    for subnet_id, subnet in data.aws_subnet.selected :
    subnet_id if subnet.available_ip_address_count > 5
  ]
}

resource "aws_security_group" "this" {
  name        = "rtlhdbsg-${local.name}"
  description = "rtlh DB Security group for ${local.name}"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, local.sec_group_tag)
  lifecycle {
    ignore_changes = [tags["db-patch-time-window"], tags["db-patch-schedule"], tags["prepatch-snapshot-flag"]]
  }
}


resource "aws_security_group_rule" "rtlh" {
  type                     = "ingress"
  count                    = length(var.ingress_rules)
  from_port                = lookup(var.ingress_rules[count.index], "from_port", 5432)
  to_port                  = lookup(var.ingress_rules[count.index], "to_port", 5432)
  protocol                 = lookup(var.ingress_rules[count.index], "protocol", "tcp")
  cidr_blocks              = lookup(var.ingress_rules[count.index], "cidr_blocks", null)
  description              = lookup(var.ingress_rules[count.index], "description", null)
  source_security_group_id = lookup(var.ingress_rules[count.index], "source_security_group_id", null)
  self                     = lookup(var.ingress_rules[count.index], "self", null)
  ipv6_cidr_blocks         = lookup(var.ingress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(var.ingress_rules[count.index], "prefix_list_ids", null)
  security_group_id        = aws_security_group.this.id

}

resource "aws_security_group_rule" "rtlh_egress" {
  type        = "egress"
  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "RTLH Egress Rule"

  security_group_id = aws_security_group.this.id

}


resource "random_password" "password" {
  length           = var.length
  keepers          = var.keepers
  lower            = var.lower
  min_lower        = var.min_lower
  min_numeric      = var.min_numeric
  min_special      = var.min_special
  min_upper        = var.min_upper
  numeric          = var.numeric
  override_special = var.override_special
  special          = var.special
  upper            = var.upper

}
