resource "oci_psql_db_system" "test_db_system" {
    #Required
    compartment_id = var.compartment_id
    db_version = var.db_system_db_version
    display_name = var.db_system_display_name
    
    network_details {
        #Required
        subnet_id = var.db_subnet_id

        #optional
        is_reader_endpoint_enabled       = var.is_reader_endpoint_enabled
        nsg_ids                          = var.nsg_ids
        primary_db_endpoint_private_ip   = var.primary_db_endpoint_private_ip
    }
    
    shape = var.db_system_shape
    
    storage_details {
        #Required
        is_regionally_durable = "false"           # Mumbai region has 1 AD 
        system_type = var.db_system_storage_details_system_type
        #Optional
        availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0]["name"]  # Mumbai region has 1 AD 
        iops = var.db_system_storage_details_iops
    }


  instance_count = var.db_system_instance_count
    # Conditionally include Flexible Shape attributes
  instance_memory_size_in_gbs = local.is_flexible_postgresql_instance_shape ? var.db_system_instance_memory_size_in_gbs : null
  instance_ocpu_count         = local.is_flexible_postgresql_instance_shape ? var.db_system_instance_ocpu_count : null

    
    credentials {
        #Required
        username = var.db_system_credentials_username
       password_details {

            password_type  = var.password_type  # Specifies how the password is stored
            password       = var.password_type == "PLAIN_TEXT" ? var.password : null
            secret_id      = var.password_type == "VAULT_SECRET" ? var.secret_id : null
            secret_version = var.password_type == "VAULT_SECRET" ? var.secret_version : null
          }
        
    }


     management_policy {

		#Optional
		backup_policy {

			#Optional
			backup_start = var.backup_start
			#days_of_the_month = var.backup_days_of_the_month
			#days_of_the_week = var.backup_days_of_the_week
			kind = var.backup_kind
			retention_days = var.retention_days
		}
    
		maintenance_window_start = var.maintenance_window_start
	}

# Use this block to create database from snapshot
  source {
		#Required
		source_type = var.source_type

		#Optional
		backup_id = var.source_type == "BACKUP" ? var.backup_id:null
		is_having_restore_config_overrides = var.db_system_source_is_having_restore_config_overrides
	}
	#system_type = var.db_system_system_type

	# Optional


# To set up Read Replica
  dynamic "patch_operations" {
    for_each = var.enable_read_replicas ? [1] : []
    content {
      operation = var.db_system_patch_operations_operation
		  selection = var.db_system_patch_operations_selection

		#Optional
		  value = var.db_system_patch_operations_value
  
    }
    
    /*
  defined_tags = {
    "testexamples-tag-namespace.demo" = "dev"
  }
  */
}
}



