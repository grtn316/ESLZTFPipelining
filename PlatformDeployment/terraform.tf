# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.46.1"
    }
  }

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "jcroth"
    workspaces {
      name = "platform"
    }
  }
}

provider "azurerm" {
  features {}
}