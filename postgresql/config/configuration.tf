resource "oci_psql_configuration" "this" {
  # Required
  compartment_id = var.compartment_id
  db_version     = var.db_version
  display_name   = var.display_name
  shape          = var.shape

  # Configuration Overrides
  db_configuration_overrides {
    items {
      config_key            = var.config_key
      overriden_config_value = var.overridden_config_value
    }
  }

  # Optional Parameters
  description                  = var.description
  instance_memory_size_in_gbs   = var.instance_memory_size_in_gbs
  instance_ocpu_count           = var.instance_ocpu_count
  is_flexible                   = var.is_flexible
  #defined_tags                  = var.defined_tags
  #freeform_tags                 = var.freeform_tags
  #system_tags                   = var.system_tags
}
