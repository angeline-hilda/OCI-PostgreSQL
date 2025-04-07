########################################################################################
#                         POSTGRESQL_DB
# This module creates Postgresql DB either as a new system or from a backup (use of source block)
# Enable read replicas and set up patch operations to set up read replicas   
# if using Vault, set secret_id and secret_version    

#OCI Database with PostgreSQL is a fully managed PostgreSQL-compatible service with intelligent sizing, tuning, and high durability.
#The service automatically scales storage as database tables are created and dropped, making management easier on you and optimizing storage spend. 
#Data is encrypted both in-transit and at rest.

##########################################################################################################
module "postgresql_db" {

  source         = "./postgresql/db_system"
  compartment_id = var.compartment_id

  db_subnet_id                   = module.network.db_subnet_id
  is_reader_endpoint_enabled     = var.is_reader_endpoint_enabled
  nsg_ids                        = var.nsg_ids
  primary_db_endpoint_private_ip = var.primary_db_endpoint_private_ip

  db_system_display_name         = var.db_system_display_name
  db_system_db_version           = var.db_system_db_version
  db_system_storage_details_iops = lookup(var.psql_iops, var.psql_iops_input != null ? var.psql_iops_input : 75)

  db_system_shape                = var.db_system_shape
  db_system_credentials_username = var.db_system_credentials_username

  password_type = var.password_type
  ####################################################################
  #if password_type is PLAIN_TEXT, input password
  #if password_type is VAULT_SECRET, input secret_id and seceret_version 
  #####################################################################
  password = var.password
  #secret_id = var.secret_id
  #secret_version = var.secret_version



  db_system_instance_count              = var.db_system_instance_count + var.replica_count
  db_system_instance_ocpu_count         = var.db_system_instance_ocpu_count
  db_system_instance_memory_size_in_gbs = var.db_system_instance_memory_size_in_gbs

  ######### Backup policy ###################

  backup_start = var.backup_start
  #days_of_the_month = var.backup_days_of_the_month
  #days_of_the_week = var.backup_days_of_the_week
  backup_kind    = var.backup_kind
  retention_days = var.retention_days

  maintenance_window_start = var.maintenance_window_start

  enable_read_replicas = var.enable_read_replicas


  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }
}


###############################################################
#     Creating Backup from a Database                         #
############################################################### 
module "postgresql_db_backup" {
  depends_on          = [module.postgresql_db]
  source              = "./postgresql/backup"
  compartment_id      = var.compartment_id
  db_system_id        = module.postgresql_db.db_system_id # Reference from DB system module
  backup_display_name = var.backup_display_name
  backup_description  = var.backup_description
  #defined_tags            = var.defined_tags
  #freeform_tags           = var.freeform_tags
  backup_retention_period = var.backup_retention_period

  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }

}


############################################################################################################
#     Creation of Custom configuration - customization of User variables
# - The custom configuration includes system and user variables which can be applied to a database system.
############################################################################################################
module "postgresql_configuration" {
  source                      = "./postgresql/config"
  compartment_id              = var.compartment_id
  db_version                  = var.config_db_version
  display_name                = var.config_display_name
  shape                       = var.config_shape
  config_key                  = var.config_key
  overridden_config_value     = var.overridden_config_value
  description                 = var.config_description
  instance_memory_size_in_gbs = var.config_instance_memory_size_in_gbs
  instance_ocpu_count         = var.config_instance_ocpu_count
  is_flexible                 = var.config_is_flexible
  #defined_tags               = var.defined_tags
  #freeform_tags              = var.freeform_tags
  #system_tags                = var.system_tags


  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }
}



########################################################################################################################################
#                     DB Custom 
# This module is for performing any customization in the database eg. creating a new database, user, enabling extentions etc using scripts

# psycopg2 - make sure to install the required python libraries used in the script
####################################################################################################################################
module "postgresql_db_custom" {
  source = "./postgresql/db_custom"

  databases       = var.databases
  host            = var.host
  master_user     = module.postgresql_db.admin_user
  master_password = var.password
  port            = var.port
  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }
}



##########################################################################################
#                           Monitoring Alarms
# - Triggers alerts when specified conditions are met.
##########################################################################################

# MQL Queries
# https://docs.oracle.com/en-us/iaas/Content/Monitoring/Reference/mql.htm

/*
- CPU utilization 
- write latency
- read latency
- database connections
*/


locals {
  postgresql_metrics = {
    "CPU Utilization" = {
      query    = format("CpuUtilization[5m]{resourceId = \"%s\"}.percentile(0.5) > %s", module.postgresql_db.db_system_id, var.cpu_utilization_alarm_threshold)
      severity = "Critical"
      summary  = "CPU Utilization exceeded threshold."
    }
    db_connections_alarm = {
      query    = format("DatabaseConnections[5m]{resourceId = \"%s\"}.mean() > %s", module.postgresql_db.db_system_id, var.db_connections_alarm_threshold)
      severity = "Warning"
      summary  = "Database connections exceeded threshold."
    }

    write_latency_alarm = {
      query    = format("WriteLatency[5m]{resourceId = \"%s\"}.percentile(0.9) > %s", module.postgresql_db.db_system_id, var.write_latency_alarm_threshold)
      severity = "Critical"
      summary  = "Write latency exceeded acceptable levels."
    }

    read_latency_alarm = {
      query    = format("ReadLatency[5m]{resourceId = \"%s\"}.percentile(0.9) > %s", module.postgresql_db.db_system_id, var.read_latency_alarm_threshold)
      severity = "Warning"
      summary  = "Read latency exceeded acceptable levels."
    }

    used_storage_alarm = {
      query    = format("UsedStorage[5m]{resourceId = \"%s\"}.percentile(0.9) > %s", module.postgresql_db.db_system_id, var.used_storage_alarm_threshold)
      severity = "Critical"
      summary  = "Used storage exceeded threshold."
    }

  }
}

module "oci_psql_monitoring" {

  depends_on         = [module.postgresql_db]
  source             = "./postgresql/monitoring"
  for_each           = local.postgresql_metrics
  compartment_id     = var.compartment_id
  destinations       = var.destinations
  alarm_display_name = "${var.db_system_display_name}-${each.key}"

  alarm_is_enabled            = var.alarm_is_enabled
  alarm_metric_compartment_id = var.compartment_id
  alarm_namespace             = var.alarm_namespace
  alarm_query                 = each.value.query
  alarm_severity              = each.value.severity

  # Optional parameters
  alarm_summary = each.value.summary
  alarm_body    = "Alert: ${each.key} crossed threshold in PostgreSQL."
  #defined_tags      = var.alarm_defined_tags
  #freeform_tags     = var.alarm_freeform_tags
  alarm_message_format      = var.alarm_message_format
  alarm_resolution          = var.alarm_resolution
  alarm_resource_group      = var.alarm_resource_group
  alarm_pending_duration    = var.alarm_pending_duration
  alarm_suppression_enabled = var.alarm_suppression_enabled

  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }
}

