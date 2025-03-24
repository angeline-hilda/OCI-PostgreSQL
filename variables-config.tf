variable "config_db_version" {
  description = "Version of PostgreSQL database"
  type        = string
}

variable "config_display_name" {
  description = "Display name for the configuration"
  type        = string
}

variable "config_shape" {
  description = "Database system shape (e.g., VM.Standard.E4.Flex)"
  type        = string
}

variable "config_key" {
  description = "Configuration variable name"
  type        = string
}

variable "overridden_config_value" {
  description = "Value to override configuration"
  type        = string
}

variable "config_description" {
  description = "Description of the configuration"
  type        = string
  default     = null
}

variable "config_instance_memory_size_in_gbs" {
  description = "Memory size in GB (Set to 0 for flexible shape)"
  type        = number
  default     = 0
}

variable "config_instance_ocpu_count" {
  description = "CPU core count (Set to 0 for flexible shape)"
  type        = number
  default     = 0
}

variable "config_is_flexible" {
  description = "Whether the configuration supports flexible shapes"
  type        = bool
  default     = false
}

/*
variable "defined_tags" {
  description = "Defined tags for the resource"
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Freeform tags"
  type        = map(string)
  default     = {}
}


variable "system_tags" {
  description = "System tags"
  type        = map(string)
  default     = {}

}

*/