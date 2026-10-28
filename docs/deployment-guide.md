# Deployment and Validation Guide

This guide is for a controlled learning lab. Run commands only in the intended subscription and review cost/security implications first.

## Prerequisites
- Terraform 1.6+
- Azure CLI
- Permissions for resource group, network, Key Vault, private endpoint, private DNS and (if enabled) role assignment creation
- A test client with a network path to the VNet, such as a VM inside it

## Authenticate and choose subscription

```bash
az login
az account list --output table
az account set --subscription "<SUBSCRIPTION_ID>"
az account show --output table
```

Verify tenant and subscription before applying changes.

## Configure and validate

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars for your lab.
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

Read the full plan. A private endpoint and other provisioned resources may incur charges. Do not apply in production without architecture/security review and approval.

## Deploy

```bash
terraform apply
terraform output
```

`workload_principal_object_id` must be the Entra object ID of a managed identity or service principal—not an app/client ID. The Terraform deployment identity needs permission to create role assignments if that optional assignment is enabled. Otherwise, assign authorization separately through your approved process.

## Validate from a connected network

From a VM/client connected to the VNet, query the vault's normal hostname:

```bash
nslookup <VAULT_NAME>.vault.azure.net
```

The name should resolve through the Key Vault private-link DNS chain to the private endpoint IP. Test TCP/443 and then authenticate with the intended workload identity before testing only the allowed operation. RBAC changes can take time to propagate.

Never place secret values in shell history, command-line arguments, CI logs, Terraform outputs or screenshots.

## CI workflow

GitHub Actions runs format, init without a backend, validation and Checkov. It does not authenticate to Azure or deploy resources. Check the repository Actions tab for actual run results.

## Destroy and cleanup

```bash
terraform plan -destroy
terraform destroy
```

Private endpoints can incur charges while provisioned. With purge protection enabled, deleted-vault recovery and name reuse follow the retention lifecycle. Follow approved retention and recovery controls.
