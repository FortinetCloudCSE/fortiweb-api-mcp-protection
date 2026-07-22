output "guacamole_access" {
  description = "Guacamole jump host — open in a browser (final output also in phase 03-routes)."
  value       = "${data.azurerm_public_ip.guac.ip_address}:8080"
}
output "guacamole_private_ip" { value = "10.10.3.200" }
output "docker_private_ips" { value = { docker1 = "10.10.1.200", docker2 = "10.10.1.202" } }
