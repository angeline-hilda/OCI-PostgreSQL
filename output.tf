output "primary_fqdn" {
  value = module.postgresql_db.primary_db_fqdn
}

output "db_ip_address" {
  value = module.postgresql_db.db_ip_address
}

output "admin_user" {
  value = module.postgresql_db.admin_user

}