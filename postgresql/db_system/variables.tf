variable "compartment_id" {
  
}

variable "db_system_db_version" {
  
}

variable "db_system_display_name" {
  
}


variable "db_subnet_id" {
  
}

variable "is_reader_endpoint_enabled" { default = false }
variable "nsg_ids" { default = [] }
variable "primary_db_endpoint_private_ip" { default = null }


variable "db_system_shape" {
  
}
variable "db_system_storage_details_iops" {
  
}

variable "db_system_storage_details_is_regionally_durable" {
  description = "Specifies if the block volume is regional or AD-local"
  type        = bool
  default     = false  # Set to false as there is only 1 AD
  
}


variable "db_system_storage_details_system_type" {
  description = "type"
  type = string
  default = "OCI_OPTIMIZED_STORAGE"
}

variable "db_system_instance_count" {
  
}

variable "db_system_instance_ocpu_count" {
  
}

variable "db_system_instance_memory_size_in_gbs" {
  
}
# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "PostgreSQL.VM.Standard3.Flex",
    "PostgreSQL.VM.Standard.E4.Flex",
    "PostgreSQL.VM.Standard.E5.Flex",
  ]
}

# Checks if is using Flexible Compute Shapes
locals {
  is_flexible_postgresql_instance_shape    = contains(local.compute_flexible_shapes, var.db_system_shape)
}

variable "db_system_credentials_username" {
  description = "username"
  type = string
  default = "admin" # example value
  
}
variable "password_type" { 
  default = "PLAIN_TEXT"
  description = "Type of password storage (PLAIN_TEXT or VAULT_SECRET)"
  type        = string 
  validation {
    condition     = contains(["PLAIN_TEXT", "VAULT_SECRET"], var.password_type)
    error_message = "password_type must be either 'PLAIN_TEXT' or 'VAULT_SECRET'."
  }
  }
variable "password" { default = null }
variable "secret_id" { default = null }
variable "secret_version" { default = null }

#Every Sunday at 2:00 AM UTC
variable "maintenance_window_start" { default = "SUN 02:00" }

variable "backup_start" { default = "00:00" }
variable "backup_days_of_the_week" { default = ["SUN"] }
variable "backup_days_of_the_month" { default = [] }
variable "backup_kind" { 
  description = "DAILY | MONTHLY | WEEKLY"
  default = "DAILY" 
  }
variable "retention_days" { default = 7 }




variable "source_type" { 
  description = "Defines if the DB is created fresh or from a backup ( NONE or BACKUP )"
  default = "NONE" 
  }

variable "backup_id" { 
  description = "Backup ID (used only if source_type is BACKUP)"
  default = null 
  }

variable "db_system_source_is_having_restore_config_overrides" {
  description = "Whether restore configuration overrides are applied"
  type        = bool
  default     = false
}

# Patch Operations Variables
variable "enable_read_replicas" {
  description = "Set to true to allow read replicas, false to disable."
  type        = bool
  default     = false
}

variable "db_system_patch_operations_operation" {
 description = "The operation to perform on the read replica database instances. Allowed values: INSERT, REMOVE."
  type        = string
  default     = "INSERT"
}

variable "db_system_patch_operations_selection" {
 description = "The selection criteria for the patch operation. Use 'instances' for INSERT, and 'instances[?id == \"var.instance_id for REMOVE."
  type        = string
  default     = "instances"
}

variable "db_system_patch_operations_value" {
 description = "Details of the instance being inserted, such as display name, description, or private IP."
  type        = map(string)
  default     = {
    displayName = ""
    description = ""
    privateIp   = ""
  }
}

