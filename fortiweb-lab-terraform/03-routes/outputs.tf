data "azurerm_public_ip" "guac" {
  name                = "pip-guacamole01"
  resource_group_name = var.resource_group_name
}

output "guacamole_access" {
  description = "Guacamole jump host — open in a browser after deployment completes."
  value       = "${data.azurerm_public_ip.guac.ip_address}:8080"
}

output "guacamole_http_url" {
  description = "Cleartext Guacamole URL (TCP/8080)."
  value       = "http://${data.azurerm_public_ip.guac.ip_address}:8080/guacamole/#/"
}

output "guacamole_https_url" {
  description = "TLS Guacamole URL (TCP/443, Azure DNS name + Let's Encrypt)."
  value       = "https://${coalesce(data.azurerm_public_ip.guac.fqdn, data.azurerm_public_ip.guac.ip_address)}/guacamole/#/"
}
