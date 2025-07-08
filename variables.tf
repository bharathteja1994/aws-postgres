variable "postgresql_parameter_option_group" {
  description = "According to the requirement DBA's can change the details."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
  default     = []
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted. Default is true."
  type        = bool
  default     = false
}

variable "dedicated_log_volume" {
  description = "Use a dedicated log volume (DLV) for the DB instance. Requires Provisioned IOPS."
  type        = bool
  default     = false
}

variable "restore_to_point_in_time" {
  description = "A configuration block for restoring a DB instance to an arbitrary point in time. Requires the identifier argument to be set with the name of the new DB instance to be created. See Restore To Point In Time below for details"
  type        = any
  default     = null
}

variable "retention_in_days_rds_postgresql" {
  description = "Specifies the number of days you want to retain Postgresql log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the Audit log group are always retained and never expire."
  type        = number
  default     = 7
}

variable "retention_in_days_rds_upgrade" {
  description = "Specifies the number of days you want to retain Alert log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the Alert log group are always retained and never expire."
  type        = number
  default     = 7
}

variable "create_postscript_log_group" {
  description = "Boolean to determine if the CloudWatch Log Group should be created for the postscripts"
  type        = bool
  default     = true
}

variable "retention_in_days_rds_postscript" {
  description = "Specifies the number of days you want to retain General log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the General log group are always retained and never expire."
  type        = number
  default     = 7
}

variable "ingress_rules" {
  description = "The parameters to create security group ingress rules in the form of a list and referencing each rule with brackets."
  default     = null
}

variable "cross_region" {
  description = "Whether the instance is a cross region replica"
  type        = bool
  default     = false
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance."
  type        = string
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
  default     = 7
  type        = string
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data. When specifying performance_insights_kms_key_id, performance_insights_enabled needs to be set to true. Once KMS key is set, it can never be changed."
  type        = string
  default     = null
}

variable "instance_count" {
  description = "The number of DB instance to create."
  default     = 1
  type        = number
}

variable "read_replica" {
  description = "Whether this instance is a read replica single region. Set false to use a single region or to create CRRR. Defaults to false"
  default     = false
}

variable "db_instance_creation_timeout" {
  description = "Used for Creating Instances, Replicas, and restoring from Snapshots. Defaults to 40 minutes."
  type        = string
  default     = "120m"

}

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier."
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes. If max_allocated_storage is configured, this argument represents the initial storage allocation and differences from the configuration will be ignored automatically when Storage Autoscaling occurs. Values by type of storage are the following: For gp2 Must be an integer from 20 to 65536, for io1 the range will be from 100 to 65536 and for standard must be from 5 to 3072. Defaults to 100"
  type        = string
  default     = null
}

variable "max_allocated_storage" {
  description = "The allocated storage in gibibytes. If max_allocated_storage is configured, this argument represents the initial storage allocation and differences from the configuration will be ignored automatically when Storage Autoscaling occurs."
  type        = string
  default     = null
}

variable "storage_type" {
  description = "One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD). The default is io1 if iops is specified, gp2 if not. Defaults to 'io1'."
  type        = string
  default     = "io1"
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN."
  type        = string
}

variable "kms_key_id_log_group" {
  description = "The ARN for the KMS encryption key for Log Groups"
  type        = string
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled. Allowed values are true/false"
  type        = bool
}

variable "engine_version" {
  description = "The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10) and this attribute will ignore differences in the patch version automatically (e.g. 5.7.17). To see available versions, please refer [pgsql-versions](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts.General.DBVersions). Defaults to 12.3"
  type        = string
  default     = "12.3"
}

variable "engine" {
  description = "The name of the database engine to be used for this DB instance. Defaults to postgres. Valid Values: postgres"
  type        = string
  default     = "postgres"
}


variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted. Must be provided if skip_final_snapshot is set to false."
  type        = string
  default     = null
}

variable "license_model" {
  description = "License model information for this DB instance"
  type        = string
  default     = "bring-your-own-license"
}

variable "instance_class" {
  description = "The instance type of the RDS instance. To see available values, please refer [Instance classes](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html)"
  type        = string
}

variable "port" {
  description = "The port on which the DB accepts connections. Defaults to 5432."
  type        = string
  default     = "5432"
}

variable "availability_zone" {
  description = "The AZ for the RDS instance. The availability_zone parameter can't be specified if the DB instance is a Multi-AZ deployment. Defaults to null."
  type        = string
  default     = null
}

variable "multi_az" {
  type        = string
  description = "Specifies if the RDS instance is multi-AZ. Allowed values are true/false. Defaults to true"
  default     = true
}

variable "iops" {
  type        = string
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of io1. Must be a multiple between .5 and 50 of the storage amount for the DB instance. Defaults to 4000."
  default     = "4000"
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60. Defaults to 0."
  type        = string
  default     = 0
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  type        = string
  default     = null
}

variable "allow_major_version_upgrade" {
  type        = string
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible. Allowed values are true/false. Defaults to true."
  default     = false
}

variable "auto_minor_version_upgrade" {
  type        = string
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Defaults to true."
  default     = false
}

variable "apply_immediately" {
  type        = string
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window. Default is false."
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'. Defaults to 'Sun:00:00-Sun:03:00'"
  type        = string
  default     = "Sun:00:00-Sun:03:00"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier. Default is false."
  default     = false
}

variable "role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role to associate with the DB Instance."
  type        = string
  default     = ""
}

variable "feature_name" {
  description = "Name of the feature for association. This can be found in the AWS documentation relevant to the integration. For RDS PGSQL it must be either s3Import or s3Export"
  type        = string
  default     = "s3Import"
}

variable "aws_db_instance_role_association" {
  description = "whether to create role association or not."
  default     = false
  type        = bool
}

variable "copy_tags_to_snapshot" {
  type        = string
  description = "Copy all Instance tags to snapshots. Default is false"
  default     = true
}

variable "backup_retention_period" {
  description = "The days to retain backups for. Must be between 0 and 35. Must be greater than 0 if the database is used as a source for a Read Replica. Defaults to 7."
  type        = string
  default     = "7"
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window. Defaults to '21:00-00:00'"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values: postgresql and upgrade. Defaults to the values mentioned above."
  type        = list(string)
  default     = ["postgresql", "upgrade"]
}

variable "deletion_protection" {
  type        = string
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false."
  default     = true
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  type        = string
  default     = null
}

variable "family" {
  description = "The family of the DB parameter group. Allowed values are 'postgres12' and 'postgres11'. Defaults to 'postgres12'."
  type        = string
  default     = "postgres12"
}

variable "serial_number" {
  description = "Database Identifier Serial number"
  type        = string
}

/***********Random*************/

variable "length" {
  type        = number
  description = "(Number) The length of the string desired."
  default     = 16
}

variable "keepers" {
  type        = map(string)
  description = "(Map of String) Arbitrary map of values that, when changed, will trigger recreation of resource. See the main provider documentation for more information"
  default     = null
}

variable "lower" {
  type        = bool
  description = "(Boolean) Include lowercase alphabet characters in the result. Default value is true."
  default     = true
}

variable "min_lower" {
  type        = number
  description = "(Number) Minimum number of lowercase alphabet characters in the result. Default value is 0."
  default     = 3
}

variable "min_numeric" {
  type        = number
  description = "(Number) Minimum number of numeric characters in the result. Default value is 0."
  default     = 3
}

variable "min_special" {
  type        = number
  description = "(Number) Minimum number of special characters in the result. Default value is 0."
  default     = 3
}

variable "min_upper" {
  type        = number
  description = "(Number) Minimum number of uppercase alphabet characters in the result. Default value is 0."
  default     = 3
}

variable "numeric" {
  type        = bool
  description = "(Boolean) Include numeric characters in the result. Default value is true."
  default     = true
}

variable "override_special" {
  type        = string
  description = "(String) Supply your own list of special characters to use for string generation. This overrides the default character list in the special argument. The special argument must still be set to true for any overwritten characters to be used in generation."
  default     = "!#$%^&"
}

variable "special" {
  type        = bool
  description = "(Boolean) Include special characters in the result. These are !@#$%&*()-_=+[]{}<>:?. Default value is true."
  default     = true
}

variable "upper" {
  type        = bool
  description = "(Boolean) Include uppercase alphabet characters in the result. Default value is true."
  default     = true
}
