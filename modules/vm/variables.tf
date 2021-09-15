variable "vm_image" {
  type = object({
    id                  = string
  })
}

variable "rg" {
}

variable "vm_prefix" {
  default = "region-tenant"
}

variable "vm_size" {
  default = "Standard_D3_v2"
}

variable "vm_userdata"{
}

variable "tags" {
  type = map
  default = {
    "cloudprovider" : "azr"
    "instancetype"  : "fw"
  }
}

variable "vm_username" {
  default = ""
}

variable "vm_passwd" {
  default = ""
}

variable "interfaces" {
  description = <<-EOF
  List of the network interface specifications.
  The first should be the Management network interface, which does not participate in data filtering.
  The remaining ones are the dataplane interfaces.
  - `subnet_id`: Identifier of the existing subnet to use.
  - `lb_backend_pool_id`: Identifier of the existing backend pool of the load balancer to associate.
  - `enable_backend_pool`: If false, ignore `lb_backend_pool_id`. Default it false.
  - `public_ip_address_id`: Identifier of the existing public IP to associate.
  Example:
  ```
  [
    {
      subnet_id            = azurerm_subnet.my_mgmt_subnet.id
      public_ip_address_id = azurerm_public_ip.my_mgmt_ip.id
    },
    {
      subnet_id           = azurerm_subnet.my_pub_subnet.id
      lb_backend_pool_id  = module.inbound_lb.backend_pool_id
      enable_backend_pool = true
    },
  ]
  ```
  EOF
}

variable "accelerated_networking" {
  default = true
}
