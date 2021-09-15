provider "azurerm" {
  features {
  }
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "main" {
  location = var.location
  name = "${var.tenant}-${var.region}-rg"
}

data "azurerm_resource_group" "image" {
  name = var.storage_image_rg

}

data "azurerm_image" "image" {
  name = var.vm_image
  resource_group_name = data.azurerm_resource_group.image.name
}

module "vnet" {
  source = "./modules/vnet"

  virtual_network_name    = "${var.tenant}-${var.region}-vnet"
  resource_group_name     = azurerm_resource_group.main.name
  location                = var.location
  address_space           = var.vnet_address_space
  network_security_groups = var.network_security_groups
  route_tables            = var.route_tables
  subnets                 = var.subnets
  tags                    = var.tags

  depends_on = [azurerm_resource_group.main]
}

module "inbound_lb" {
  source = "./modules/load_balancer"

  resource_group      = azurerm_resource_group.main
  name                = "${var.tenant}-${var.region}-ilb"
  probe_name          = "${var.tenant}-${var.region}-ilb-probe"
  backend_name        = "${var.tenant}-${var.region}-ilb-backend"
  frontend_ips        = {
    pip-new   = {
      create_public_ip     = true
      public_ip_address_id = ""
      rules = {
        HTTPS = {
          port         = 443
          protocol     = "Tcp"
        }
      }
    }
  }
  depends_on = [module.vnet]
}

module "nat_gateway" {
  source  = "./modules/nat_gateway"

  name_prefix         = "${var.tenant}-${var.region}"
  create_public_ip    = true
  resource_group      = azurerm_resource_group.main
  subnet_ids          = [lookup(module.vnet.subnet_ids, "subnet-dp", null)]

  depends_on = [module.vnet]
}

module "vm" {
  source = "./modules/vm"

  for_each = var.vm_instances

  vm_image = data.azurerm_image.image
  rg = azurerm_resource_group.main
  vm_prefix = "${var.tenant}-${var.region}-${each.key}-vm"
  interfaces = [
    {
      name                = "${var.tenant}-${var.region}-${each.key}-vm-mgmt-nic"
      subnet_id           = lookup(module.vnet.subnet_ids, "subnet-mgmt", null)
      create_public_ip    = true
    },
    {
      name                 = "${var.tenant}-${var.region}-${each.key}-vm-dp-nic"
      subnet_id            = lookup(module.vnet.subnet_ids, "subnet-dp", null)
      lb_backend_pool_id   = module.inbound_lb.backend_pool_id
      enable_backend_pool  = true
    },
    {
      name                = "${var.tenant}-${var.region}-${each.key}-vm-ha-nic"
      subnet_id           = lookup(module.vnet.subnet_ids, "subnet-ha", null)
    },
  ]
  vm_userdata = each.value.userdata
  vm_size = each.value.size

  depends_on = [module.vnet]
}
