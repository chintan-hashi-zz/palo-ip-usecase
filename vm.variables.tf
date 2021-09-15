variable "vm_instances"{
}

variable "tags" {
  type = map
  default = {
    "cloudprovider" : "azr"
    "instancetype"  : "fw"
  }
}
