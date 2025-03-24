#https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/postgresql/metrics.htm

resource "oci_monitoring_alarm" "db_alarm" {
  compartment_id            = var.compartment_id
  destinations              = var.destinations
  display_name              = var.alarm_display_name
  is_enabled                = var.alarm_is_enabled
  metric_compartment_id     = var.alarm_metric_compartment_id
  namespace                 = var.alarm_namespace
  query                     = var.alarm_query
  severity                  = var.alarm_severity

  # Optional parameters
  alarm_summary     = var.alarm_summary
  body              = var.alarm_body
  #defined_tags      = var.alarm_defined_tags
  #freeform_tags     = var.alarm_freeform_tags
  message_format    = var.alarm_message_format
  resolution        = var.alarm_resolution
  resource_group    = var.alarm_resource_group
  pending_duration  = var.alarm_pending_duration
  dynamic "suppression" {
    for_each = var.alarm_suppression_enabled ? [1] : []
    content {
      time_suppress_from  = var.alarm_suppression_time_suppress_from
      time_suppress_until = var.alarm_suppression_time_suppress_until
      description = var.alarm_suppression_description
  }
 }
}