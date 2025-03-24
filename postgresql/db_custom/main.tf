resource "null_resource" "create_db" {
  for_each = toset(var.databases)

  provisioner "local-exec" {
    command = "python ${path.module}/create_database.py"
    environment = {
      HOST              = var.host
      DATABASE          = each.value
      MASTER_USER       = var.master_user
      MASTER_PASSWORD   = var.master_password
      PORT              = var.port
    }
  }
}
