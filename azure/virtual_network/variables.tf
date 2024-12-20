variable "resource_group_location" {
  type        = string
  default     = "swedencentral"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "vnet-rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}



variable "vnet_cidr_block" {
  type    = set(string)
  default = ["10.0.0.0/16"]
}