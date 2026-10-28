# Azure Key Vault — Interview Notes (Basic to Advanced)

## 1. What is Azure Key Vault?
A managed Azure service for safeguarding secrets, cryptographic keys and certificates. Typical uses include application credentials, API tokens, encryption keys and certificate lifecycle management.

## 2. Secrets vs keys vs certificates
- **Secret:** a password, token or connection string.
- **Key:** cryptographic material for operations such as encryption, decryption, signing or verification.
- **Certificate:** identity/PKI data that combines a public key with certificate metadata and associated private-key handling depending on configuration.

## 3. How should a workload authenticate?
Prefer Microsoft Entra ID with Managed Identity where supported. This avoids embedding workload credentials in source code. The identity still needs authorized permissions and network reachability.

## 4. Azure RBAC or access policies?
Azure RBAC is generally recommended for new designs needing centralized, scope-aware authorization. Legacy vaults may use access policies. Check the configured authorization model before assigning permissions.

## 5. What is a Private Endpoint?
It provides private connectivity to a supported Azure service through a private IP in a VNet. Key Vault's private-link DNS zone is commonly `privatelink.vaultcore.azure.net`.

## 6. Why is Private DNS important?
The normal vault hostname must resolve to the private endpoint IP from the intended network. Incorrect DNS can make a correctly configured private endpoint appear unreachable.

## 7. Why can RBAC be correct but a request times out?
Authorization is not network connectivity. The client may be outside the VNet, lack routes/peering, be blocked by firewall policy, or resolve the vault hostname incorrectly. Test DNS and TCP from the workload network before changing roles.

## 8. Why can a connected workload receive 403?
It may use the wrong identity, lack the required role or scope, attempt an operation not covered by its role, or hit propagation delay.

## 9. Soft delete vs purge protection?
Soft delete retains deleted vaults/objects for recovery during a retention period. Purge protection helps prevent permanent deletion before retention expires.

## 10. How do you protect Terraform state?
Use a secured remote backend, strict identity permissions, encryption, locking where supported, audit/access controls and recovery/versioning. State may contain sensitive values even if outputs are marked sensitive. Never commit state or plan files.

## 11. How should GitHub Actions authenticate to Azure?
Prefer OIDC/workload identity federation with short-lived tokens instead of long-lived client secrets. Restrict repository/environment trust, permissions and deployment scope.

## 12. Does Checkov prove the configuration is secure?
No. Static analysis detects known patterns of possible misconfiguration. Combine it with design review, runtime tests, organizational policy, audit logs and threat modelling.

## 13. A secret is leaked in a commit. What now?
Treat it as compromised; rotate/revoke it, investigate possible use, clean up accessible files/artifacts, follow history cleanup and incident procedures, and introduce secret scanning. Removing the current file alone is insufficient.

## 14. Private endpoint works in dev but not production. How do you troubleshoot?
Compare DNS answers, private DNS links, VNet peering, routes, firewall/NSG rules, endpoint connection state and caller identity. Test from the production workload subnet; do not weaken public access as a shortcut.

## 15. What belongs in an operational runbook?
Ownership, RBAC/access review, secret/certificate rotation, audit logs and alerts, retention/recovery policy, incident escalation, connectivity checks, change review and evidence of periodic testing.
