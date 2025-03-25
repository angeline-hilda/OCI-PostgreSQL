variable "compartment_ocid" {
  type        = string
  description = "The OCID of the compartment to contain the VCN."
}

variable "lockdown_default_seclist" {
  description = "whether to remove all default security rules from the VCN Default Security List"
  default     = true
  type        = bool
}
variable "enable_ipv6" {
  type        = bool
  default     = false
  description = "Compartment : Option to enable ipv6"
}

#vcn details
variable "vcn1_vcn_cidr_block" {
  description = "The  IPv4 CIDR block the VCN will use."
  default     = ["10.0.0.0/16"]
  type        = list(string)
}
variable "vcn1_vcn_display_name" {
  type        = string
  description = "The vcn1_vcn_display_name"
  default     = "demo_vcn"
}
variable "vcn1_vcn_dns_label" {
  type        = string
  description = "The vcn1_vcn_dns_label"
  default     = "vcn1vcn"
}

#lb subnet details
variable "public_subnet_cidr_block" {
  type        = string
  description = "The lb_subnet_cidr_block"
  default     = "10.0.20.0/24"
}
variable "public_subnet_display_name" {
   type        = string
  description = "The lb_subnet_display_name"
  default = "public_subnet"
}
variable "public_subnet_dns_label" {
  type        = string
  description = "The lb subnet dns label"
  default     = "publicsub"
}


variable "db_subnet_cidr_block" {
   type        = string
  description = "The db_subnet_cidr_block"
  default = "10.0.30.0/24"
}
variable "db_subnet_display_name" {
   type        = string
  description = "The db_subnet_display_name"
  default = "private_subnet"
}
variable "db_subnet_dns_label"{
    type        = string
  description = "The db_subnet_dns_label"
  default     = "dbsub"
}


variable "public_ingress_rules" {
  description = "List of ingress rules for the public subnet"
  type        = list(object({
    protocol = string
    source   = string
    min      = optional(number)
    max      = optional(number)
    icmp_type = optional(number)
    icmp_code = optional(number)
  }))
}


variable "db_ingress_rules" {
  description = "List of ingress rules for the database subnet"
  type        = list(object({
    protocol = string
    source   = string
    min      = optional(number)
    max      = optional(number)
    icmp_type = optional(number)
    icmp_code = optional(number)
  }))
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
