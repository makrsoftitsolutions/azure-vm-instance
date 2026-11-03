# Azure VM Instance

## Deployment prerequisites

- Create the GitHub repository variables `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `TF_STATE_RESOURCE_GROUP`, `TF_STATE_STORAGE_ACCOUNT`, and `TF_STATE_CONTAINER`.
- Create the GitHub secret `VM_ADMIN_SSH_PUBLIC_KEY` with the SSH public key for the VM administrator.
- The Terraform state storage account and container must already exist. Grant the deployment identity `Storage Blob Data Contributor` on the state container.
- The initial deployment identity must be allowed to create Entra applications and service principals, and must have permission to create subscription role assignments (for example, `Owner` or `User Access Administrator` plus `Contributor`). The workflow-created identity is provisioned by Terraform and cannot bootstrap itself.
- Configure the GitHub OIDC subject to match the configured subject exactly: `repo:makrsoftitsolutions@348376686/azure-vm-instance@1443840336:*`.

The network security group intentionally allows SSH (22) from any IPv4 source, as requested. Restrict that rule to trusted CIDRs before deploying into a production environment.