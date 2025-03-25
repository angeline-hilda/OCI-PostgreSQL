output "vcn_id_vcn1_id" {
  value = oci_core_vcn.vcn1.id
}


output "public_subnet_id" {
  value = oci_core_subnet.public_subnet.id
}

output "db_subnet_id" {
  value = oci_core_subnet.db_subnet.id
}

output "public_subnet_subnet_type" {
  value = oci_core_subnet.public_subnet.prohibit_public_ip_on_vnic
}

output "db_subnet_subnet_type" {
  value = oci_core_subnet.db_subnet.prohibit_public_ip_on_vnic
}
