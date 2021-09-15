# output "virtual_network" {
#   description = "The identifier of the created Virtual Network."
#   value       = module.vnet.virtual_network
# }

# output "subnet_ids" {
#   description = "The identifiers of the created Subnets."
#   value = module.vnet.subnet_ids
# }

# output "network_security_groups" {
#   description = "The identifiers of the created Network Security Groups."
#   value = module.vnet.network_security_groups
# }

# output "route_tables" {
#   description = "The identifiers of the created Route Tables."
#   value = module.vnet.route_tables
# }

output "frontend_ip_configs" {
  value       = module.inbound_lb.frontend_ip_configs
  description = "Map of IP addresses, one per each entry of `frontend_ips` input. Contains public IP address for the frontends that have it, private IP address otherwise."
}

output "nat_gateway_name" {
  description = "Nat gateway Name"
  value       = module.nat_gateway.nat_gateway_name
}

output "nat_gateway_public_ips" {
  description = "Public IPs associated to Nat Gateway"
  value       = module.nat_gateway.nat_gateway_public_ips
}
