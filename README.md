# AKS Hub-and-Spoke Baseline

This Terraform configuration provisions an AKS prerequisite foundation in `centralindia`:

- A hub VNet (`10.100.0.0/16`) containing `AzureFirewallSubnet`, `GatewaySubnet`, and `HubMgmtSubnet`.
- An AKS spoke VNet (`10.200.0.0/16`) containing system, user, and Application Gateway subnets.
- Bidirectional hub/spoke VNet peering.
- Azure Firewall Standard and a Standard public IP.
- Premium Azure Container Registry and standard Key Vault, both private-only with private endpoints and private DNS zones.
- A Log Analytics workspace with diagnostic settings for Firewall, ACR, and Key Vault.

The AKS cluster, node pools, Bastion host, and Application Gateway are intentionally not deployed by this baseline. Their subnets and service dependencies are prepared for a later workload deployment. The firewall is provisioned but no UDRs or firewall rules are configured; route tables and workload-specific allow rules should be designed with the AKS egress requirements before enforcing forced tunneling.

## Terraform state

The root configuration declares an empty `azurerm` backend. GitHub Actions injects backend settings at initialization and stores this baseline in the existing `makrsoftstorage` storage account, `tfstate` container, under the separate key `aks-hub-spoke-dev.tfstate`. The separate key prevents this configuration from overwriting the former VM deployment's state. Configure the GitHub Actions variable `TF_STATE_RESOURCE_GROUP` with the resource group containing `makrsoftstorage`.

The GitHub deployment identity needs OIDC access, permission to read and write blobs in the state container (for example, Storage Blob Data Contributor), and permission to create the requested resources in the deployment resource group. Its Azure role-assignment permissions may be scoped according to your organization's deployment policy.

## Dry run

The GitHub Actions workflow runs formatting, initialization, validation, and `terraform plan` only; it does not provision resources. Before using the plan, configure the GitHub secrets `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and `AZURE_SUBSCRIPTION_ID`, and the repository variable `TF_STATE_RESOURCE_GROUP`.

For a local plan, authenticate with Azure CLI and initialize the same backend:

```bash
az login
export ARM_SUBSCRIPTION_ID="<subscription-id>"
export TF_VAR_subscription_id="$ARM_SUBSCRIPTION_ID"
terraform init -input=false \
  -backend-config="resource_group_name=<state-resource-group>" \
  -backend-config="storage_account_name=makrsoftstorage" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=aks-hub-spoke-dev.tfstate" \
  -backend-config="use_azuread_auth=true"
terraform fmt -check -recursive
terraform validate
terraform plan
```

Review the plan, estimated costs, and regional availability before applying. To apply intentionally, run `terraform apply` only after review. Azure Firewall, private endpoints, and Premium ACR incur ongoing charges.

The ACR and Key Vault names include a generated suffix to meet Azure's global-name uniqueness requirements. Private endpoints are placed in `AksSystemSubnet`; its private-endpoint network policies are disabled. The Key Vault uses Azure RBAC, soft delete, and purge protection. This baseline does not grant application identities data-plane roles; grant only the needed roles once the AKS/workload identities are defined.
