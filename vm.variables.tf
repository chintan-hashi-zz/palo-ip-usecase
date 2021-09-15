variable "vm_instances"{
  "1000" = {
    size = "Standard_D3_v2"
    userdata = "mgmt-interface-swap=enable"
  }
}

variable "tags" {
  type = map
  default = {
    "cloudprovider" : "azr"
    "instancetype"  : "fw"
  }
}
