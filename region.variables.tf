#############TENANT-REGION-VARIABLES####################
variable "location" {
  default = "West US"
}

variable "subscription_id" {
  default = "96b22718-5b32-43e7-9005-5561c1bfedf7"
}

variable "tenant_id" {
  default = "66b66353-3b76-4e41-9dc3-fee328bd400e"
}

variable "region" {
  default = "200"
}

variable "tenant" {
  default = "renault"
}

#############VM-IMAGE-VARIABLES####################
variable "storage_image_rg" {
  default = "PrismaAccessPoc"
}

variable "vm_image" {
  default = "papoc-seattle-saas-c243"
}
