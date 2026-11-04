# AKS Hub-and-Spoke Baseline

This Terraform configuration provisions an AKS prerequisite foundation in `centralindia`:

- Reuses the existing resource groups: VNets, private endpoints, and private DNS in `rg-network`; ACR in `rg-platform`; Key Vault in `rg-security`; and Log Analytics in `rg-monitoring`. It does not create or manage `rg-app-dev`.
- A hub VNet (`10.100.0.0/16`) containing `GatewaySubnet` and `HubMgmtSubnet`.
- An AKS spoke VNet (`10.200.0.0/16`) containing system, user, and Application Gateway subnets.
- Bidirectional hub/spoke VNet peering.
- Premium Azure Container Registry and standard Key Vault, both private-only with private endpoints and private DNS zones.
- A Log Analytics workspace with diagnostic settings for ACR and Key Vault.

The AKS cluster, node pools, Bastion host, Application Gateway, and Azure Firewall are intentionally not deployed by this baseline. Their subnets and service dependencies are prepared for a later workload deployment. Egress filtering is not provided. The Azure Policy assignment currently denies public IP creation, which Azure Firewall requires in this design; reintroduce a firewall only after an administrator approves a policy-compliant egress design.

## Terraform state

The root configuration declares an empty `azurerm` backend. GitHub Actions injects backend settings at initialization and stores this baseline in the existing `makrsoftstorage` storage account, `tfstate` container, under the separate key `aks-hub-spoke-dev.tfstate`. The separate key prevents this configuration from overwriting the former VM deployment's state. Configure the GitHub Actions variable `TF_STATE_RESOURCE_GROUP` with the resource group containing `makrsoftstorage`.

Resource-group names and location are passed directly from configuration; Terraform does not query the resource-group metadata during planning. The GitHub deployment identity needs OIDC access, permission to read and write blobs in the state container (for example, Storage Blob Data Contributor), and resource read/write permissions for the managed services in `rg-network`, `rg-platform`, `rg-security`, and `rg-monitoring`. The latest apply failed because it lacks at least `Microsoft.ContainerRegistry/registries/read`, `Microsoft.KeyVault/vaults/read`, and `Microsoft.OperationalInsights/workspaces/read`. An Azure administrator must grant an appropriate least-privilege role or custom role at these resource-group scopes (for example, Contributor if permitted by your organization's policy). Terraform cannot grant these permissions to the identity that is running it. This configuration does not create role assignments.

The AzureRM provider is configured to register core resource providers. This requires the deployment identity to have provider-registration permissions at subscription scope; if your policy does not allow that, have a subscription administrator register required providers before deployment and change `resource_provider_registrations` to `none`. Do not grant the CI identity broad subscription permissions solely for provider registration. The required providers include `Microsoft.Resources`, `Microsoft.Network`, `Microsoft.ContainerRegistry`, `Microsoft.KeyVault`, `Microsoft.OperationalInsights`, and `Microsoft.Insights`.

## Deployment workflow

The GitHub Actions workflow runs formatting, initialization, validation, and `terraform plan -out=tfplan` on pushes to `main` and manual workflow dispatch, displays the saved plan, then automatically applies that exact plan with `terraform apply -auto-approve tfplan`. It can change Azure resources without a separate approval, and displaying the plan does not pause for review. Before running it, configure the GitHub secrets `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and `AZURE_SUBSCRIPTION_ID`, and the repository variable `TF_STATE_RESOURCE_GROUP`. Do not trigger another apply until the deployment identity has the required Azure read/write permissions and the plan is checked against the partially applied state.

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

Review the plan, estimated costs, and regional availability before applying changes. A prior apply removed `AzureFirewallSubnet` and then failed on resource read authorization. Inspect the next plan carefully for changes resulting from that partial apply before allowing another apply. Private endpoints and Premium ACR incur ongoing charges.

The ACR and Key Vault names include a generated suffix to meet Azure's global-name uniqueness requirements. Private endpoints are placed in `AksSystemSubnet`; its private-endpoint network policies are disabled. Diagnostic settings are Azure extension resources attached to their target services, so they cannot be independently assigned to `rg-monitoring`; they send logs to the workspace in that group. The Key Vault uses Azure RBAC, soft delete, and purge protection. This baseline does not grant application identities data-plane roles; grant only the needed roles once the AKS/workload identities are defined.

## Azure resource inventory

The separate `Azure resource inventory` workflow can be run manually from GitHub Actions or runs daily at 06:00 UTC. It signs in with the existing `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and `AZURE_SUBSCRIPTION_ID` OIDC secrets, performs read-only Azure Resource Graph and VM queries, and uploads `resources.csv`, `resources.json`, and `summary.md` as a 14-day workflow artifact. The identity needs Reader access to the selected subscription and permission to query Azure Resource Graph. No Azure resources are changed.

The inventory includes provisioning state, VM power state (for example, running or stopped/deallocated), and Azure Resource Health availability when reported. Runtime and health states are service-specific; `Not reported` means Azure did not return that state for the resource. Azure Resource Graph health data is not a real-time monitor. VM power states come from the Azure VM list operation.
