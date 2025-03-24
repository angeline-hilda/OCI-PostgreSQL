variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

variable "db_version" {
  description = "Version of the PostgreSQL database"
  type        = string
}

variable "display_name" {
  description = "A user-friendly name for the configuration"
  type        = string
}

variable "shape" {
  description = "The shape of the configuration (e.g., VM.Standard.E4.Flex)"
  type        = string
}

variable "config_key" {
  description = "Configuration variable name"
  type        = string
}

variable "overridden_config_value" {
  description = "User-selected variable value"
  type        = string
}

variable "description" {
  description = "Description for the configuration"
  type        = string
  default     = null
}

variable "instance_memory_size_in_gbs" {
  description = "Memory size in GB (Set to 0 for flexible shapes)"
  type        = number
  default     = 0
}

variable "instance_ocpu_count" {
  description = "CPU core count (Set to 0 for flexible shapes)"
  type        = number
  default     = 0
}

variable "is_flexible" {
  description = "Whether the configuration supports flexible shapes"
  type        = bool
  default     = false
}

/*
variable "defined_tags" {
  description = "Defined tags"
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