# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "PostgreSQL.VM.Standard3.Flex",
    "PostgreSQL.VM.Standard.E4.Flex",
    "PostgreSQL.VM.Standard.E5.Flex",
  ]
}

# Checks if is using Flexible Compute Shapes
locals {
  is_flexible_postgresql_instance_shape    = contains(local.compute_flexible_shapes, var.db_system_shape)
}