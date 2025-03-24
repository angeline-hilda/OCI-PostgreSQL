variable "backup_display_name" {
  description = "A user-friendly display name for the backup."
  type        = string
}

variable "backup_description" {
  description = "A description for the backup."
  type        = string
  default     = "Daily automated backup"
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