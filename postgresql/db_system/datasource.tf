# Get Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Get Fault Domains for the first Availability Domain
data "oci_identity_fault_domains" "FaultDomains" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0]["name"]
  compartment_id      = var.compartment_id
}

data "oci_psql_db_system_connection_detail" "test_db_system_connection_detail" {
  db_system_id = oci_psql_db_system.test_db_system.id
}


