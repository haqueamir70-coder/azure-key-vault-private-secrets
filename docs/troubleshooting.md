# Azure Key Vault Troubleshooting Playbook

## 403 Forbidden

Likely causes include the wrong caller identity, missing data-plane role, an incorrect role scope, an operation not covered by the role, or propagation delay.

1. Identify the real caller: user, service principal or managed identity.
2. Verify RBAC role and scope on the correct vault.
3. Check the requested operation is allowed by the role.
4. Confirm network access separately; control-plane permissions do not grant data-plane access.
5. Allow time for RBAC propagation and retest.

## DNS returns a public IP or no answer

1. Query the normal vault hostname from inside the intended workload network.
2. Confirm the private endpoint is provisioned and approved.
3. Check the A record in `privatelink.vaultcore.azure.net`.
4. Confirm the private DNS zone is linked to the correct VNet.
5. For hub/spoke, VPN or on-prem clients, validate DNS forwarding/resolver design.
6. Flush client DNS cache where appropriate and test again.

## Connection timeout

- Confirm the client routes to the private endpoint IP.
- Review NSGs, user-defined routes, firewall rules and peering.
- Check the private endpoint connection state.
- Verify TCP/443 from the actual workload network.
- Public network access is disabled by design; an arbitrary internet client should not connect.

## Terraform role assignment failure

- Verify `workload_principal_object_id` is an Entra object ID, not an application/client ID.
- Confirm the Terraform deployment identity can create role assignments at the requested scope.
- Confirm principal and vault are in the expected tenant.

## Vault name unavailable after destroy

Key Vault names are globally unique. Soft delete and purge protection can cause a deleted vault name to remain unavailable during retention. Plan unique lab names and use approved recovery processes.

## A credential was committed accidentally

1. Treat it as compromised and rotate/revoke it immediately.
2. Investigate possible use and exposure in logs/artifacts.
3. Remove exposed data from current files and follow incident procedures for history cleanup.
4. Add secret scanning and review how the leak occurred.

Removing a line from the latest commit does not make an exposed credential safe. Never commit real secrets, state files or sensitive plan artifacts.
