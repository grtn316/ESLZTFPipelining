terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.46.1"
    }
    random = {
      version = ">=3.0"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "jcroth"
    workspaces {
      name = "akslab"
    }
  }
}

provider "azurerm" {
  # subscription_id = var.subscription_id
  # tenant_id       = var.tenant_id
  features {}
}
