output "db_system_id" {
  value = oci_psql_db_system.test_db_system.id
}

output "admin_user" {
    value = oci_psql_db_system.test_db_system.admin_username
  
}

output "primary_db_fqdn" {
  value = data.oci_psql_db_system_connection_detail.test_db_system_connection_detail.primary_db_endpoint[0].fqdn
}

output "db_ip_address" {
  value = data.oci_psql_db_system_connection_detail.test_db_system_connection_detail.primary_db_endpoint[0].ip_address
}

output "ca_certificate" {
    value = data.oci_psql_db_system_connection_detail.test_db_system_connection_detail.ca_certificate
  
}

resource "local_file" "oci_pg_ca_cert" {
  content  = data.oci_psql_db_system_connection_detail.test_db_system_connection_detail.ca_certificate
  filename = "${path.module}/oci_pg_cert.pem"
}