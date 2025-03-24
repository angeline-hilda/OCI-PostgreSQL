variable "compartment_id" {
  description = "The OCID of the compartment where the resources will be created."
  type        = string
}

variable "destinations" {
    description = "A list of destinations for alarm notifications."
  
}
variable "alarm_display_name" {
  type = string
}

variable "alarm_metric_compartment_id" {
  type = string
}

variable "alarm_namespace" {
  type = string
}

variable "alarm_query" {
  type = string
}

variable "alarm_severity" {
  type = string
}

variable "alarm_is_enabled" {
  type = bool
  default = true
}
/*
variable "alarm_notification_topic_id" {
  type = string
}
*/

variable "alarm_summary" {
  type    = string
  default = "PostgreSQL alarm triggered"
}

variable "alarm_body" {
  type    = string
  default = "The alarm has been triggered based on the query conditions."
}

/*
variable "alarm_defined_tags" {
  type    = map(string)
  default = {}
}

variable "alarm_freeform_tags" {
  type    = map(string)
  default = {}
}
*/

variable "alarm_message_format" {
  type    = string
  default = "RAW"
}

variable "alarm_resolution" {
  type    = string
  default = "1m"
}

variable "alarm_resource_group" {
  type    = string
  default = null
}

variable "alarm_pending_duration" {
  type    = string
  default = "PT5M"
}

variable "alarm_suppression_time_suppress_from" {
  type    = string
  default = null
}

variable "alarm_suppression_time_suppress_until" {
  type    = string
  default = null
}

variable "alarm_suppression_description" {
  type    = string
  default = "Maintenance suppression"
}
variable "alarm_suppression_enabled" {
    type = bool
    default = false
  
}