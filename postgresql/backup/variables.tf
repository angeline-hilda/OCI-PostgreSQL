variable "compartment_id" {
  description = "The OCID of the compartment that contains the backup."
  type        = string
}

variable "db_system_id" {
  description = "The ID of the PostgreSQL database system."
  type        = string
}

variable "backup_display_name" {
  description = "A user-friendly display name for the backup."
  type        = string
}

variable "backup_description" {
  description = "A description for the backup."
  type        = string
  default     = "Automated backup"
}
/*
variable "defined_tags" {
  description = "Defined tags for the backup."
  type        = map(string)
  default     = {}
}


variable "freeform_tags" {
  description = "Simple key-value pair applied without predefined name or scope."
  type        = map(string)
  default     = {}
}

*/
variable "backup_retention_period" {
  description = "Backup retention period in days."
  type        = number
  default     = 7
}

