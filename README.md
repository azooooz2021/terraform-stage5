# Chatbot Infrastructure on Azure with Terraform

This repository contains Terraform configurations to provision infrastructure for a chatbot application on Microsoft Azure. The infrastructure includes a Virtual Network, Subnet, Network Security Group, Public IP, Managed Disk, Network Interface, and a Virtual Machine running Ubuntu 24.04 LTS. After provisioning, the chatbot application (frontend, backend, and database) can be deployed manually on the VM, with systemd services to manage them.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Deploying the Application](#deploying-the-application)
- [Systemd Services](#systemd-services)
- [Accessing the Chatbot](#accessing-the-chatbot)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview
This project uses Terraform to provision a scalable and secure infrastructure for a chatbot application on Azure. The infrastructure is modular, following Terraform best practices for reusability and maintainability. The VM is configured with Ubuntu 24.04 LTS, a 30GB managed disk, and the `Standard_D2ads_v6` instance type. The application is deployed manually, with systemd services ensuring the database, backend, and frontend run reliably.

## Architecture
The infrastructure includes:
- **Azure Resource Group**: Container for all resources.
- **Virtual Network (VNet)**: Private network with a `10.0.0.0/16` address space.
- **Subnet**: Subnetwork (`10.0.1.0/24`) for the VM.
- **Network Security Group (NSG)**: Firewall rules allowing SSH (port 22) and HTTP (port 80).
- **Public IP**: Static IP for accessing the VM.
- **Managed Disk**: 30GB disk for application data.
- **Network Interface**: Connects the VM to the VNet and Public IP.
- **Virtual Machine**: Ubuntu 24.04 LTS with `Standard_D2ads_v6` instance type.

## Prerequisites
Before using this project, ensure you have:
- **Terraform**: Version `>= 1.5.0` installed ([installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)).
- **Azure CLI**: Installed and authenticated ([installation guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)).
- **Azure Subscription**: Active subscription with permissions to create resources.
- **SSH Key Pair**: Generate an SSH key pair (`~/.ssh/id_rsa.pub` and `~/.ssh/id_rsa`) for VM access.
- **Git**: Installed to clone and manage the repository.

## Project Structure
```
chatbot_infra/
├── main.tf                # Root module calling network, storage, and compute modules
├── variables.tf           # Input variables for customization
├── outputs.tf             # Outputs (e.g., VM public IP)
├── terraform.tfvars       # Variable values
├── provider.tf            # Azure provider and backend configuration
├── modules/
│   ├── network/           # VNet, Subnet, NSG, Public IP
│   ├── compute/           # VM, Network Interface, Disk Attachment
│   └── storage/           # Managed Disk
├── README.md              # This file
```

## Setup Instructions
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/azooooz2021/terraform-stage5.git
   cd terraform-stage5
   ```

2. **Configure Azure Credentials**:
   - Log in to Azure using the CLI:
     ```bash
     az login
     ```
   - Set your subscription (if needed):
     ```bash
     az account list
     ```

3. **Update Variables** (optional):
   - Edit `terraform.tfvars` to customize values (e.g., `resource_group_name`, `location`, `ssh_public_key_path`).
   - Example:
     ```hcl
     resource_group_name = "chatbot-rg"
     location            = "westus2"
     prefix              = "chatbot"
     disk_size_gb        = 30
     vm_size             = "Standard_D2ads_v6"
     admin_username      = "azureuser"
     ssh_public_key_path = "~/.ssh/id_rsa.pub"
     ```

4. **Initialize Terraform**:
   ```bash
   terraform init
   ```

5. **Review the Plan**:
   ```bash
   terraform plan -out=tfplan
   ```

6. **Apply the Configuration**:
   ```bash
   terraform apply tfplan
   ```
   - Note the `public_ip_address` output for accessing the VM.

7. **Access the VM**:
   ```bash
   ssh azureuser@<public_ip_address>
   ```
