

/*variable "db_subnet_id" {

}
*/

variable "is_reader_endpoint_enabled" { default = false }
variable "nsg_ids" { default = [] }
variable "primary_db_endpoint_private_ip" { default = null }


variable "db_system_db_version" {
  description = "Version"
  type        = number
  default     = 14
}

variable "db_system_display_name" {
  description = "postgress db service name"
  type        = string
  default     = "psqlfromterraform" # example value
}

#https://docs.oracle.com/en-us/iaas/Content/postgresql/supported-shapes.htm
variable "db_system_shape" {
  description = "shape"
  type        = string
  default     = "PostgreSQL.VM.Standard.E4.Flex" # example value
  #change the shape value as per your requirements
}

variable "db_system_instance_count" {
  description = "instance count"
  type        = number
  default     = 3 # example value
}

variable "db_system_instance_memory_size_in_gbs" {
  description = "RAM"
  type        = number
  default     = 32 # example value
}

variable "db_system_instance_ocpu_count" {
  description = "OCPU count"
  type        = number
  default     = 2 # example value
}

variable "psql_iops" {
  type = map(number)
  default = {
    75  = 75000
    150 = 150000
    225 = 225000
    300 = 300000
  }
}

variable "psql_iops_input" {
  type    = number
  default = null

}




variable "db_system_credentials_username" {
  description = "Database username"
  type        = string
  default     = "admin" # example value

}

variable "password_type" {
  default     = "PLAIN_TEXT"
  description = "Type of password storage (PLAIN_TEXT or VAULT_SECRET)"
  type        = string
  validation {
    condition     = contains(["PLAIN_TEXT", "VAULT_SECRET"], var.password_type)
    error_message = "password_type must be either 'PLAIN_TEXT' or 'VAULT_SECRET'."
  }
}

variable "password" {
  description = "Database password (only used if password_type is PLAIN_TEXT)"
  default     = null
}
variable "secret_id" {
  description = "Vault secret ID (only used if password_type is VAULT_SECRET)"
  default     = null
}
variable "secret_version" {
  description = "Version of the secret in Vault"
  default     = null
}


variable "maintenance_window_start" { default = "SUN 02:00" }

variable "backup_start" { default = "00:00" }
variable "backup_days_of_the_week" { default = ["SUN"] }
variable "backup_days_of_the_month" { default = [] }
variable "backup_kind" {
  description = "DAILY | MONTHLY | WEEKLY"
  default     = "DAILY"
}

variable "retention_days" { default = 7 }


variable "source_type" {
  description = "Defines if the DB is created fresh or from a backup ( NONE or BACKUP )"
  default     = "NONE"
}

variable "backup_id" {
  description = "Backup ID (used only if source_type is BACKUP)"
  default     = null
}

variable "db_system_source_is_having_restore_config_overrides" {
  description = "Whether restore configuration overrides are applied"
  type        = bool
  default     = false
}


# Patch Operations Variables
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
  default = {
    displayName = ""
    description = ""
    privateIp   = ""
  }
}

variable "enable_read_replicas" {
  description = "Set to true to allow read replicas, false to disable."
  type        = bool
  default     = false
}