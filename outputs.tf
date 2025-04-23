output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = module.network.public_ip_address
}