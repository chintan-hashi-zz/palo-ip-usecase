data "azurerm_public_ip" "existing_public_ip" {
  name                = "gcp_pip"
  resource_group_name = "gcp_pip_rg"
}

resource "azurerm_public_ip" "public_ip" {
  for_each = { for k, v in var.interfaces : k => v if try(v.create_public_ip, false) }

  location            = var.rg.location
  resource_group_name = var.rg.name
  name                = each.value.name
  name                = "existing_pip"
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = try(each.value.tags, var.tags)
}

resource "azurerm_network_interface" "nic" {
  count = length(var.interfaces)

  name                          = "${var.vm_prefix}-${var.interfaces[count.index].name}"
  location                      = var.rg.location
  resource_group_name           = var.rg.name
  enable_accelerated_networking = count.index == 0 ? false : var.accelerated_networking # for interface 0 it is unsupported by PAN-OS
  enable_ip_forwarding          = true
  tags                          = try(var.interfaces[count.index].tags, var.tags)

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.interfaces[count.index].subnet_id
    private_ip_address_allocation = try(var.interfaces[count.index].private_ip_address, null) != null ? "Static" : "Dynamic"
    private_ip_address            = try(var.interfaces[count.index].private_ip_address, null)
    #public_ip_address_id          = try(azurerm_public_ip.public_ip[count.index].id, var.interfaces[count.index].public_ip_address_id, null)
    public_ip_address_id          = try(var.interfaces[count.index].create_public_ip, false) == true ? data.azurerm_public_ip.existing_public_ip.id : null
  }
  depends_on = [data.azurerm_public_ip.existing_public_ip]
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_address" {
  for_each = { for k, v in var.interfaces : k => v if try(v.enable_backend_pool, false) }

  backend_address_pool_id = each.value.lb_backend_pool_id
  ip_configuration_name   = azurerm_network_interface.nic[each.key].ip_configuration[0].name
  network_interface_id    = azurerm_network_interface.nic[each.key].id
}

resource "azurerm_virtual_machine" "vm" {
  location = var.rg.location

  name = "${var.vm_prefix}-vm"

  primary_network_interface_id = azurerm_network_interface.nic[0].id

  network_interface_ids = [for k, v in azurerm_network_interface.nic : v.id]

  resource_group_name = var.rg.name

  vm_size = var.vm_size

  os_profile {

    admin_username = var.vm_username

    admin_password = var.vm_passwd

    computer_name = "${var.vm_prefix}"

    custom_data = var.vm_userdata
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_image_reference {
    id = var.vm_image.id
  }

  storage_os_disk {
    caching = "ReadWrite"

    create_option = "FromImage"

    managed_disk_type = "Standard_LRS"

    name = "${var.vm_prefix}-osdisk"
  }

  identity {
    type = "SystemAssigned"
  }

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  tags = var.tags

}
