data "azurerm_public_ip" "guac" {
  name                = "pip-guacamole01"
  resource_group_name = var.resource_group_name
}

output "guacamole_access" {
  description = "Guacamole jump host — open in a browser after deployment completes."
  value       = "${data.azurerm_public_ip.guac.ip_address}:8080"
}
