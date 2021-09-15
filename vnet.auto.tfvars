vnet_address_space = ["240.4.0.0/16"]

subnets =   {
  "subnet-mgmt" = {
    address_prefixes       = ["240.4.1.0/24"]
    network_security_group = "mgmt_nsg"
    route_table            = "mgmt_route_table"
  },
  "subnet-dp" = {
    address_prefixes       = ["240.4.5.0/24"]
    network_security_group = "dp_nsg"
    route_table            = "dp_route_table"
  },
  "subnet-ha" = {
    address_prefixes       = ["240.4.9.0/24"]
    network_security_group = "ha_nsg"
    route_table            = "ha_route_table"
  },
}

network_security_groups =  {
  "mgmt_nsg" = {
    rules = {
      "AllowinboundfromCorp" = {
        priority                = 1001
        direction               = "Inbound"
        access                  = "Allow"
        protocol                = "*"
        source_port_range       = "*"
        destination_port_range  = "*"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
      "Allowall_Outbound" = {
        priority               = 1003
        direction              = "Outbound"
        access                 = "Allow"
        protocol               = "Tcp"
        source_port_range      = "*"
        destination_port_range = "*"
        source_address_prefix  = "*"
        destination_address_prefix = "*"
      }
    }
  },
  "dp_nsg" = {
    rules = {
      "AllowinboundfromCorp" = {
        priority                = 1001
        direction               = "Inbound"
        access                  = "Allow"
        protocol                = "*"
        source_port_range       = "*"
        destination_port_range  = "*"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
      "Allowall_Outbound" = {
        priority               = 1003
        direction              = "Outbound"
        access                 = "Allow"
        protocol               = "Tcp"
        source_port_range      = "*"
        destination_port_range = "*"
        source_address_prefix  = "*"
        destination_address_prefix = "*"
      }
    }
  },
  "ha_nsg" = {
    rules = {
      "AllowinboundfromCorp" = {
        priority                = 1001
        direction               = "Inbound"
        access                  = "Allow"
        protocol                = "*"
        source_port_range       = "*"
        destination_port_range  = "*"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
      "Allowall_Outbound" = {
        priority               = 1003
        direction              = "Outbound"
        access                 = "Allow"
        protocol               = "Tcp"
        source_port_range      = "*"
        destination_port_range = "*"
        source_address_prefix  = "*"
        destination_address_prefix = "*"
      }
    }
  },
}

route_tables =  {
  "mgmt_route_table" = {
    routes = {
    }
  },
  "dp_route_table" = {
    routes = {
    }
  },
  "ha_route_table" = {
    routes = {
    }
  },
}
