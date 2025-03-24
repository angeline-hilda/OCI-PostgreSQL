variable "databases" {
  
}
variable "host" {
  
}
variable "master_user" {
  
}
variable "master_password" {
  
}

variable "port" {
  
}

/*
variable "ca_certificate" {
  
}
*/


variable "db_extensions" {
  type = set(string)
  description = "List of extensions to be created in the database"
  default = []
}