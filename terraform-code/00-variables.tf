variable "location" {
  description = "Region where all resources will be created"
  type        = string
  default     = "centralindia"
}

variable "resource_group_name" {
  description = "Name of Resource Group"
  type        = string
  default     = "terraform-aks"
}

variable "environment" {
  description = "Environment to deploy"
  type        = string
  # default     = "dev"
}

variable "ssh_public_key" {
  description = "SSH public key for Linux k8s nodes"
  # default     = "/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
}

variable "windows_admin_username" {
  description = "Windows k8s nodes Username"
  type        = string
  default     = "azureuser"
}

variable "windows_admin_password" {
  description = "Windows k8s nodes Password for user login"
  type        = string
  default     = "P@ssw@rd123456"
}