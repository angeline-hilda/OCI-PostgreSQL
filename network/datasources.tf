data "oci_core_services" "vcn1_services" {
    filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}