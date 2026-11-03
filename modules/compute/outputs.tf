output "vm_id" {
  description = "Resource ID of the deployed Linux virtual machine."
  value       = azurerm_linux_virtual_machine.main.id
}
