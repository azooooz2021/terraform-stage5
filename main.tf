module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  prefix              = var.prefix
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  prefix              = var.prefix
  disk_size_gb        = var.disk_size_gb
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = module.network.resource_group_name
  location            = var.location
  prefix              = var.prefix
  subnet_id           = module.network.subnet_id
  public_ip_id        = module.network.public_ip_id
  nsg_id              = module.network.nsg_id
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  ssh_public_key_path = var.ssh_public_key_path
  disk_id             = module.storage.disk_id
}


