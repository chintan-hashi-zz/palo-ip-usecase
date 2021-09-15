output "mgmt_ip_address" {
  description = "management IP address. If `create_public_ip` was `true`, it is a public IP address, otherwise a private IP address."
  value       = try(var.interfaces[0].create_public_ip, false) ? azurerm_public_ip.public_ip[0].ip_address : azurerm_network_interface.nic[0].ip_configuration[0].private_ip_address
}

output "private_ip" {
  description = "management IP address. If `create_public_ip` was `true`, it is a public IP address, otherwise a private IP address."
  value       = try(var.interfaces[0].create_public_ip, false) ? azurerm_public_ip.public_ip[0].ip_address : azurerm_network_interface.nic[0].ip_configuration[0].private_ip_address
}

output "interfaces" {
  description = "List of VM network interfaces. The elements of the list are `azurerm_network_interface` objects. The order is the same as `interfaces` input."
  value       = azurerm_network_interface.nic
}

output "principal_id" {
  description = "The oid of Azure Service Principal of the created VM-Series. Usable only if `identity_type` contains SystemAssigned."
  value       = azurerm_virtual_machine.vm.identity[0].principal_id
}
