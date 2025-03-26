#########################################################################
# Security List for Load Balancer (Public Subnet)
#########################################################################

resource "oci_core_security_list" "public_securitylist" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "public_SecurityList"

  dynamic "ingress_security_rules" {
    for_each = var.public_ingress_rules
    content {
      protocol = ingress_security_rules.value.protocol
      source   = ingress_security_rules.value.source

      dynamic "tcp_options" {
        #for_each = lookup(ingress_security_rules.value, "min", null) != null ? [1] : []
        for_each = (lookup(ingress_security_rules.value, "min", null) != null && lookup(ingress_security_rules.value, "max", null) != null) ? [1] : []
        content {
          min = ingress_security_rules.value.min
          max = ingress_security_rules.value.max
        }
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = var.public_egress_rules
    content {
      protocol    = egress_security_rules.value.protocol
      destination = egress_security_rules.value.destination
    }
  }
}

resource "oci_core_security_list" "db_securitylist" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "DBSecurityList"

  dynamic "ingress_security_rules" {
    for_each = var.db_ingress_rules
    content {
      protocol = ingress_security_rules.value.protocol
      source   = ingress_security_rules.value.source

      dynamic "tcp_options" {
        for_each = (lookup(ingress_security_rules.value, "min", null) != null && lookup(ingress_security_rules.value, "max", null) != null) ? [1] : []
        content {
          min = ingress_security_rules.value.min
          max = ingress_security_rules.value.max
        }
      }

      dynamic "icmp_options" {
        #for_each = lookup(ingress_security_rules.value, "icmp_type", null) != null ? [1] : []
        for_each = (lookup(ingress_security_rules.value, "icmp_type", null) != null && lookup(ingress_security_rules.value, "icmp_code", null) != null) ? [1] : []
        content {
          type = ingress_security_rules.value.icmp_type
          code = ingress_security_rules.value.icmp_code
        }
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = var.db_egress_rules
    content {
      protocol    = egress_security_rules.value.protocol
      destination = egress_security_rules.value.destination
    }
  }
}




























