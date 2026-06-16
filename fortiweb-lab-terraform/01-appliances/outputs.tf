output "fortigate_private_ips" { value = { outside = "10.10.3.101", inside = "10.10.2.101" } }
output "fortiweb_private_ips" { value = { protected = "10.10.2.100", server = "10.10.1.100" } }
