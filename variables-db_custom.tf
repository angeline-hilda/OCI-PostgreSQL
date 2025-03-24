variable "databases" {

}

variable "host" {

}


variable "port" {
  type    = number
  default = 5432
}


variable "db_extensions" {
  type        = set(string)
  description = "List of extensions to be created in the database"
  default     = []
}
