resource "oci_psql_backup" "this" {
  # Required
  compartment_id = var.compartment_id
  db_system_id   = var.db_system_id
  display_name   = var.backup_display_name

  # Optional
  #defined_tags     = var.defined_tags
  #freeform_tags    = var.freeform_tags
  description      = var.backup_description

  retention_period = var.backup_retention_period
}
