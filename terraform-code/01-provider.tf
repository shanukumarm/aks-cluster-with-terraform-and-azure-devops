# Terraform Settings Block
# 1. Required Version Terraform
# 2. Required Terraform Providers
# 3. Terraform Remote State Storage with Azure Storage Account 
terraform {
  required_version = ">= 1.6.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.78.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.45.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }

  # For utilize tfstate from remote location
  backend "azurerm" {
    # resource_group_name  = "terraform-storage-for-tfstate"
    # storage_account_name = "tfstateremotebackup"
    # container_name       = "tfstatefiles"
    # key                  = "dev.terraform.tfstate"
  }
}

# Terraform Provider Block for AzureRM 
provider "azurerm" {
  features {}
}


# 3. Terraform Resource Block: Define a Random Pet Resource
resource "random_pet" "aksrandom" {

}