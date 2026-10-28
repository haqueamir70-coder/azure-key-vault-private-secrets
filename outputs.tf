output "resource_group_name" {
  description = "Resource group hosting the lab."
  value       = azurerm_resource_group.this.name
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "Vault URI; data-plane access still requires private network access and RBAC."
  value       = azurerm_key_vault.this.vault_uri
}

output "private_endpoint_id" {
  description = "Private endpoint resource ID."
  value       = azurerm_private_endpoint.key_vault.id
}

output "private_dns_zone_name" {
  description = "Private DNS zone for Key Vault."
  value       = azurerm_private_dns_zone.key_vault.name
}
