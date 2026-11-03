# Azure VM Instance

## Deployment

This project deploys a single Ubuntu 22.04 VM (`Standard_B1s`) in `eastus`, with Docker Engine and the Docker Compose V2 plugin installed by cloud-init. The VM uses a Standard_LRS OS disk, a static public IP, a VNet/subnet, a default internet route, and an NSG for SSH and HTTP.

- Set GitHub repository **secrets**:
  - `AZURE_CLIENT_ID`: `52703820-8f9a-4c76-b151-507677e01d1e`
  - `AZURE_TENANT_ID`: `a24223b8-0a32-4862-922d-d3f2545866a2`
  - `AZURE_SUBSCRIPTION_ID`: `aa61b080-74f9-41ed-a75f-8e60a60ccae4`
  - `VM_ADMIN_SSH_PUBLIC_KEY`: SSH public key installed for the VM administrator
- Set repository **variables** `TF_STATE_RESOURCE_GROUP`, `TF_STATE_STORAGE_ACCOUNT`, and `TF_STATE_CONTAINER` for the existing Terraform state storage. The container and storage account must already exist.
- Grant the deployment identity `Storage Blob Data Contributor` on the state container. The identity also needs permission to read the existing application and service principal, manage the application's federated credentials, create subscription role assignments, and deploy subscription resources. This typically requires application ownership or `Application.ReadWrite.All` plus Azure `Owner`/`User Access Administrator` at the subscription.
- The existing application is client ID `52703820-8f9a-4c76-b151-507677e01d1e`, object ID `53fbfbcf-26a1-4235-995e-9ed994f758c1`. The federated subject must exactly match the `main` branch token: `repo:makrsoftitsolutions@348376686/azure-vm-instance@1443840336:ref:refs/heads/main`.
- The existing federated credential `azure-vm-instance-main-trust` is imported into Terraform state by the import block. It must already be present before GitHub Actions can sign in.

If `azure/login@v2` fails with `AADSTS700213`, update the existing credential once from an authenticated Azure CLI session (the Terraform workflow cannot do this first because Azure login runs before Terraform):

```bash
az ad app federated-credential update \
  --id 52703820-8f9a-4c76-b151-507677e01d1e \
  --federated-credential-id 786b8838-ce12-4394-a1b7-7f56016f4d57 \
  --parameters '{
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:makrsoftitsolutions@348376686/azure-vm-instance@1443840336:ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"],
    "description": "Allows azure-vm-instance repo to deploy via OIDC"
  }'
```

Pushes to `main` and manual workflow dispatch run `terraform plan` followed by `terraform apply`. For local deployment, authenticate with `az login`, initialize the same remote backend using `TF_STATE_RESOURCE_GROUP`, `TF_STATE_STORAGE_ACCOUNT`, and `TF_STATE_CONTAINER`, then run `terraform plan` and `terraform apply`. Provide `vm_admin_ssh_public_key` through a `TF_VAR_vm_admin_ssh_public_key` environment variable or a local `*.tfvars` file that is not committed.

The NSG allows SSH (22) from any IPv4 source by default and HTTP (80) from any IPv4 source. Set `ssh_source_address_prefix` to a trusted CIDR before production use. Adding a user to the `docker` group grants root-equivalent privileges.