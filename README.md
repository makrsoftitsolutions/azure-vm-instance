# Azure VM Instance

## Deployment prerequisites

- Create the GitHub repository variables `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `TF_STATE_RESOURCE_GROUP`, `TF_STATE_STORAGE_ACCOUNT`, and `TF_STATE_CONTAINER`. Set `AZURE_CLIENT_ID` to `52703820-8f9a-4c76-b151-507677e01d1e` (the app's client ID, not its object ID), and `AZURE_SUBSCRIPTION_ID` to `aa61b080-74f9-41ed-a75f-8e60a60ccae4`.
- Create the GitHub secret `VM_ADMIN_SSH_PUBLIC_KEY` with the SSH public key for the VM administrator.
- The Terraform state storage account and container must already exist. Grant the deployment identity `Storage Blob Data Contributor` on the state container.
- The existing Entra application with object ID `53fbfbcf-26a1-4235-995e-9ed994f758c1` and its service principal are used for GitHub Actions authentication. The identity running Terraform must be able to read them, manage the application's federated identity credentials, and create subscription role assignments (for example, `Owner` or `User Access Administrator` plus `Contributor`).
- Configure the GitHub OIDC subject to match the configured subject exactly: `repo:makrsoftitsolutions@348376686/azure-vm-instance@1443840336:*`.
- Terraform imports the existing `azure-vm-instance-main-trust` federated credential (`786b8838-ce12-4394-a1b7-7f56016f4d57`) on its next apply. Since the workflow signs in before running Terraform, the credential must already exist on the app before the first workflow run.

The network security group intentionally allows SSH (22) from any IPv4 source, as requested. Restrict that rule to trusted CIDRs before deploying into a production environment.