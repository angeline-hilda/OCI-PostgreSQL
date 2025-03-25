

module "network" {
  source                = "./network"
  compartment_ocid      = var.compartment_id
  vcn1_vcn_display_name = var.vcn1_vcn_display_name
  vcn1_vcn_dns_label    = var.vcn1_vcn_dns_label
  vcn1_vcn_cidr_block   = var.vcn1_vcn_cidr_block

  public_subnet_cidr_block   = var.public_subnet_cidr_block
  public_subnet_display_name = var.public_subnet_display_name
  #public_subnet_dns_label           = var.public_subnet_dns_label

  db_subnet_cidr_block   = var.db_subnet_cidr_block
  db_subnet_display_name = var.db_subnet_display_name
  #db_subnet_dns_label               = var.db_subnet_dns_label





  public_ingress_rules = try(var.public_ingress_rules, [])
  public_egress_rules  = try(var.public_egress_rules, [])

  db_ingress_rules = try(var.db_ingress_rules, [])
  db_egress_rules  = try(var.db_egress_rules, [])


  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }
}
