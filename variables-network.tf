# -----------------------------------------------------------------------------
#  network Variables
# -----------------------------------------------------------------------------

variable "enable_ipv6" {
  type        = bool
  default     = false
  description = "Compartment : Option to enable ipv6"
}

variable "vcn1_vcn_cidr_block" {
  description = "The IPv4 CIDR block the VCN will use."
  default     = ["10.0.0.0/16"]
  type        = list(string)
}

variable "vcn1_vcn_dns_label" {
  type        = string
  description = "The vcn1_vcn_dns_label"
  default     = "vcn1vcn"
}
variable "vcn1_vcn_display_name" {
  type        = string
  description = "The vcn1_vcn_display_name"
  default     = "vcn1_vcn"
}

variable "lockdown_default_seclist" {
  description = "whether to remove all default security rules from the VCN Default Security List"
  default     = true
  type        = bool
}


variable "public_subnet_cidr_block" {
  type        = string
  description = "The hub_subnet_priv01_cidr_block"
  default     = "10.0.20.0/24"
}
variable "db_subnet_cidr_block" {
  type        = string
  description = "The hub_subnet_priv01_cidr_block"
  default     = "10.0.30.0/24"
}

variable "public_ingress_rules" {
  description = "List of ingress rules for the public subnet"
  type = list(object({
    protocol  = string
    source    = string
    min       = optional(number)
    max       = optional(number)
    icmp_type = optional(number)
    icmp_code = optional(number)
  }))
}


variable "db_ingress_rules" {
  description = "List of ingress rules for the database subnet"
  type = list(object({
    protocol  = string
    source    = string
    min       = optional(number)
    max       = optional(number)
    icmp_type = optional(number)
    icmp_code = optional(number)
  }))
}


variable "public_subnet_display_name" {
  description = "Display name for public subnet"

}

variable "db_subnet_display_name" {
  description = "Display name for Database subnet"

}

variable "public_egress_rules" {
  type = list(object({
    protocol    = string
    destination = string
  }))
}

variable "db_egress_rules" {
  type = list(object({
    protocol    = string
    destination = string
  }))
}

