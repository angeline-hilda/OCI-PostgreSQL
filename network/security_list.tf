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
/*
resource "oci_core_security_list" "public_securitylist" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
  display_name   = "public_SecurityList"

  dynamic "ingress_security_rules" {
    for_each = [
      { protocol = "6", source = "0.0.0.0/0", min = 22, max = 22 },   # SSH
      { protocol = "6", source = "0.0.0.0/0", min = 80, max = 80 },   # HTTP
      { protocol = "6", source = "0.0.0.0/0", min = 443, max = 443 }  # HTTPS
    ]
    content {
      protocol = ingress_security_rules.value["protocol"]
      source   = ingress_security_rules.value["source"]

      tcp_options {
        min = ingress_security_rules.value["min"]
        max = ingress_security_rules.value["max"]
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = ["0.0.0.0/0"]  # Allow outbound traffic
    content {
      protocol    = "6"
      destination = egress_security_rules.value
    }
  }
}

#########################################################################
# Security List for Database (Private Subnet)
#########################################################################
resource "oci_core_security_list" "db_securitylist" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
  display_name   = "DBSecurityList"

  dynamic "ingress_security_rules" {
    for_each = [
      { protocol = "6", source = local.public_subnet_id, min = 22, max = 22 },     # SSH from Public Subnet
      { protocol = "6", source = local.public_subnet_id, min = 3389, max = 3389 }, # RDP from Public Subnet
      { protocol = "6", source = local.public_subnet_id, min = 5432, max = 5432 }, # PostgreSQL
      { protocol = "6", source = local.public_subnet_id, min = 6379, max = 6379 }, # Redis
      { protocol = "1", source = "0.0.0.0/0", icmp_type = 3, icmp_code = 4 }       # ICMP Ping
    ]
    content {
      protocol = ingress_security_rules.value["protocol"]
      source   = ingress_security_rules.value["source"]

      dynamic "tcp_options" {
        for_each = ingress_security_rules.value["min"] != null ? [1] : []
        content {
          min = ingress_security_rules.value["min"]
          max = ingress_security_rules.value["max"]
        }
      }

      dynamic "icmp_options" {
        for_each = ingress_security_rules.value["icmp_type"] != null ? [1] : []
        content {
          type = ingress_security_rules.value["icmp_type"]
          code = ingress_security_rules.value["icmp_code"]
        }
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = ["0.0.0.0/0"]
    content {
      protocol    = "6"
      destination = egress_security_rules.value
    }
  }
}



*/































#########################################################################
#security list rules for worker nodes 
#########################################################################

/*
resource "oci_core_security_list" "node_securitylist" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.oke.id
  display_name   = "NodeSecurityList"

#########################  ingress rules  ###################################
  ingress_security_rules {
    protocol = "all"
    source   = var.node_subnet_cidr_block
    description = "Allow pods on one worker node to communicate with pods on other worker nodes"  
  }
  
  ingress_security_rules {
    // allow ICMP for all type 3 code 4
    protocol = "1"
    source   = var.api_subnet_cidr_block
    description = "Path discovery"
    icmp_options {
      type = "3"
      code = "4"
    }
  }

   ingress_security_rules {
    // allow tcp all for kube api
    protocol = "6"
    source   = var.api_subnet_cidr_block
    description = "TCP access from Kubernetes Control Plane"
    #tcp_options {
    #  max = "all"
    #  min = "all"
    #}
  }

  ingress_security_rules {
    //allow ssh
    protocol = "6"
    source   = "0.0.0.0/0"
    description = "Inbound SSH traffic to worker nodes"
    tcp_options {
      max = "22"
      min = "22"
    }
  }

######################### egress rules  ###################################

  egress_security_rules {
    protocol = "all"
    destination_type = "CIDR_BLOCK"
    destination   = var.node_subnet_cidr_block
    description = "Allow pods on one worker node to communicate with pods on other worker nodes"
  } 
  
  egress_security_rules {
    // allow ICMP for all type 3 code 4
    protocol = "6"
    destination_type = "CIDR_BLOCK"
    destination  = var.api_subnet_cidr_block
    description = "Access to Kubernetes API Endpoint"
    tcp_options {
      max = "6443"
      min = "6443"
    }
  }

  egress_security_rules {
    // allow ICMP for all type 3 code 4
    protocol = "6"
    destination_type = "CIDR_BLOCK"
    destination  = var.api_subnet_cidr_block
    description = "Kubernetes worker to control plane communication"
    tcp_options {
      max = "12250"
      min = "12250"
    }
  }

  egress_security_rules {
    // allow ICMP for all type 3 code 4
    protocol = "1"
    destination_type = "CIDR_BLOCK"
    destination  = var.api_subnet_cidr_block
    description = "Path discovery"
    icmp_options {
      type = "3"
      code = "4"
    }
  }
  
  egress_security_rules {
    // allow ICMP for all type 3 code 4
    protocol = "1"
    destination  = "0.0.0.0/0"
    description = "ICMP Access from Kubernetes Control Plane"
    icmp_options {
      type = "3"
      code = "4"
    }
  }
  egress_security_rules {
    // allow ICMP for all type 3 code 4
    protocol = "6"
    destination_type = "SERVICE_CIDR_BLOCK"
    destination      = lookup(data.oci_core_services.oke_services.services[0], "cidr_block")
    description = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
    tcp_options {
      max = "443"
      min = "443"
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}
*/

/*

#########################################################################
#security list rules for k8s api endpoint
#########################################################################

resource "oci_core_security_list" "api_securitylist" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.oke.id
  display_name   = "api_endpoint_SecurityList"

#########################  ingress rules  ###################################
ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    description = "External access to Kubernetes API endpoint"  
    tcp_options {
      max = "6443"
      min = "6443"
    }
  }

ingress_security_rules {
    protocol = "6"
    source   = var.node_subnet_cidr_block
    description = "Kubernetes worker to Kubernetes API endpoint communication"  
    tcp_options {
      max = "6443"
      min = "6443"
    }
  }

ingress_security_rules {
    protocol = "6"
    source   = var.node_subnet_cidr_block
    description = "Kubernetes worker to control plane communication"  
    tcp_options {
      max = "12250"
      min = "12250"
    }
  }

ingress_security_rules {
    // allow ICMP for all type 3 code 4
    protocol = "1"
    source   = var.node_subnet_cidr_block
    description = "Path discovery"
    icmp_options {
      type = "3"
      code = "4"
    }
  }
#########################  egress rules  ###################################
egress_security_rules {
    // allow ICMP for all type 3 code 4
    protocol = "6"
    destination_type = "SERVICE_CIDR_BLOCK"
    destination      = lookup(data.oci_core_services.oke_services.services[0], "cidr_block")
    description = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
    tcp_options {
      max = "443"
      min = "443"
    }
  }
egress_security_rules {
    protocol    = "6"
    destination_type = "CIDR_BLOCK"
    destination = var.node_subnet_cidr_block
    description = "All traffic to worker nodes"
  #  tcp_options {
  #    max = "all"
  #    min = "all"
  #  }
  }  
egress_security_rules {
    // allow ICMP for all type 3 code 4
    protocol = "1"
    destination_type = "CIDR_BLOCK"
    destination = var.node_subnet_cidr_block
    description = "Path discovery"
    icmp_options {
      type = "3"
      code = "4"
    }
  }
}
*/

