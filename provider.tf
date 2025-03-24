# # -----------------------------------------------------------------------------
# # Provider Requirements if using stack as a module
# # -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# Support for multi-region deployments
# -----------------------------------------------------------------------------

data "oci_identity_region_subscriptions" "regions" {
  tenancy_id = var.tenancy_id
}

terraform {
  required_version = "1.9.0"
  required_providers {
    oci = {
      source  = "opentofu/oci"
      version = "=6.24.0"
    }

  }

}

provider "oci" {
  tenancy_ocid = var.tenancy_id
  user_ocid    = var.user_id
  region       = var.region
}
provider "oci" {
  alias        = "home_region"
  tenancy_ocid = var.tenancy_id
  user_ocid    = var.user_id
  region       = var.home_region
}
