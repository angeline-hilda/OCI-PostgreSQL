######################################################################
#                      Create network components                     # 
######################################################################
resource "oci_core_vcn" "vcn1" {
  cidr_blocks    = var.vcn1_vcn_cidr_block[*]
  dns_label      = var.vcn1_vcn_dns_label
  compartment_id = var.compartment_ocid
  display_name   = var.vcn1_vcn_display_name
  is_ipv6enabled = var.enable_ipv6
}

#   subnets
resource "oci_core_subnet" "public_subnet" {
  cidr_block     = var.public_subnet_cidr_block
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = var.public_subnet_display_name
  dns_label      =var.public_subnet_dns_label 
  prohibit_public_ip_on_vnic = false
  route_table_id = oci_core_route_table.vcn1_public_route_table.id
  security_list_ids = [oci_core_security_list.public_securitylist.id]
}

resource "oci_core_subnet" "db_subnet" {
  cidr_block     = var.db_subnet_cidr_block
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  dns_label      = var.db_subnet_dns_label
  display_name   = var.db_subnet_display_name
  prohibit_public_ip_on_vnic = true
  route_table_id = oci_core_route_table.vcn1_private_route_table.id
  security_list_ids = [oci_core_security_list.db_securitylist.id]
}


#gateways
#IGW
resource "oci_core_internet_gateway" "vcn1_internet_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  enabled        = "true"
  display_name   = "Internet_Gateway"
}
#natGW
resource "oci_core_nat_gateway" "vcn1_nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name = "NAT_Gateway"
}
#serviceGW
resource "oci_core_service_gateway" "vcn1_service_gateway"{
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name = "Service_Gateway"
  services {
  service_id = lookup(data.oci_core_services.vcn1_services.services[0], "id")
  }
}

#default route table
resource "oci_core_route_table" "vcn1_public_route_table" {
 
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "vcn1-public-route-table"

  route_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.vcn1_internet_gateway.id
  }
}

#route table for private subnets
resource "oci_core_route_table" "vcn1_private_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn1.id
  display_name = "Private_route_Table"
  route_rules {
    network_entity_id = oci_core_nat_gateway.vcn1_nat_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  route_rules{
    network_entity_id = oci_core_service_gateway.vcn1_service_gateway.id
    destination       = lookup(data.oci_core_services.vcn1_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
  }
}
