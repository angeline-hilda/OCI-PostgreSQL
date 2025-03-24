 terraform {
   required_version = "1.9.0"
   required_providers {
     oci = {
       source                = "opentofu/oci"
       version               = "=6.24.0" 
       configuration_aliases = [oci, oci.home_region]
     }

   }
 }