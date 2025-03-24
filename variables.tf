# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------
variable "tenancy_id" {
  type        = string
  description = "The OCID of tenancy"
}

variable "home_region" {
  type        = string
  description = "The OCI home region"

}

variable "region" {
  type        = string
  description = "The OCI region"
}

variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment"

}

variable "user_id" {
  type        = string
  description = "The user OCID"

}

variable "api_fingerprint" {

}
variable "api_private_key_path" {


}

#availability domain parameters
variable "availability_domain_number" {
  description = "Availability Domain Number for App & DB"
  default     = "1"
}



