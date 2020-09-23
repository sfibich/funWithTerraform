variable "prefix" {
	type = string
  description = "The prefix which should be used for all resources in this module"
	default = "work"
}

variable "location" {
	type = string
  description = "The Azure Region in which all resources in this module"
	default = "eastus2"
}
