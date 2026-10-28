variable "location" {
  description = "Azure region for the lab."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
  default     = "rg-kv-private-lab"
}

variable "name_prefix" {
  description = "Prefix for names; use 3-18 letters, numbers, and hyphens."
  type        = string
  default     = "kv-private-lab"

  validation {
    condition     = length(var.name_prefix) >= 3 && length(var.name_prefix) <= 18 && can(regex("^[A-Za-z][A-Za-z0-9-]*[A-Za-z0-9]$", var.name_prefix))
    error_message = "name_prefix must be 3-18 characters, start with a letter, end with a letter or number, and contain only letters, numbers, or hyphens."
  }
}

variable "vnet_address_space" {
  description = "Virtual network CIDR blocks."
  type        = list(string)
  default     = ["10.40.0.0/16"]
}

variable "private_endpoint_subnet_prefix" {
  description = "Address prefix reserved for private endpoints."
  type        = list(string)
  default     = ["10.40.1.0/24"]
}

variable "workload_principal_object_id" {
  description = "Optional Microsoft Entra object ID to grant Key Vault Secrets User. Leave empty to assign separately."
  type        = string
  default     = ""
}
