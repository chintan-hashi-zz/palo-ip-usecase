output "virtual_network" {
  description = "The identifier of the created Virtual Network."
  value       = azurerm_virtual_network.vnet
}

output "subnet_ids" {
  description = "The identifiers of the created Subnets."
  value = {
    for k, v in azurerm_subnet.subnet : k => v.id
  }
}

output "network_security_groups" {
  description = "The identifiers of the created Network Security Groups."
  value = {
    for k, v in azurerm_network_security_group.nsg : k => v
  }
}

output "route_tables" {
  description = "The identifiers of the created Route Tables."
  value = {
    for k, v in azurerm_route_table.route_table : k => v
  }
}
