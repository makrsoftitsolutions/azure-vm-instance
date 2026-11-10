# Azure VM Instance

## Deployment prerequisites

- Create the GitHub repository variables `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `TF_STATE_RESOURCE_GROUP`, `TF_STATE_STORAGE_ACCOUNT`, and `TF_STATE_CONTAINER`.
- Create the GitHub secret `VM_ADMIN_SSH_PUBLIC_KEY` with the SSH public key for the VM administrator.
- The Terraform state storage account and container must already exist. Grant the deployment identity `Storage Blob Data Contributor` on the state container.
- The initial deployment identity must be allowed to create Entra applications and service principals, and must have permission to create subscription role assignments (for example, `Owner` or `User Access Administrator` plus `Contributor`). The workflow-created identity is provisioned by Terraform and cannot bootstrap itself.
- Configure the GitHub OIDC subject to match the configured subject exactly: `repo:makrsoftitsolutions@348376686/azure-vm-instance@1443840336:*`.

The network security group intentionally allows SSH (22) from any IPv4 source, as requested. Restrict that rule to trusted CIDRs before deploying into a production environment.

## Destroying infrastructure

The **Destroy Azure infrastructure** workflow is manual-only. Dispatch it, select the GitHub Actions environment whose state should be destroyed, then set `confirm_destroy` to `yes`. Configure each environment with required reviewers and its Azure OIDC variables. The `production` environment uses the existing `azure-vm-instance.tfstate`; other environments use `azure-vm-instance-<environment>.tfstate`. The workflow refuses to proceed when the selected state is empty, then plans the destruction and applies that exact saved plan. Choosing `no` skips the destroy job.

Configure the repository variables `AZURE_DESTROY_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `TF_STATE_RESOURCE_GROUP`, `TF_STATE_STORAGE_ACCOUNT`, and `TF_STATE_CONTAINER`, and keep the `VM_ADMIN_SSH_PUBLIC_KEY` secret available. The teardown identity must have the GitHub OIDC federated credential and sufficient Azure permissions to delete the Terraform-managed resources and role assignments, plus `Storage Blob Data Contributor` on the Terraform state container. Use a separate identity from the Terraform-managed deployment identity to avoid removing the caller's own access during teardown.