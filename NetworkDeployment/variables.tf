# Base Variables 

# variable "tenant_id" {

# }

# variable "subscription_id" {

# }

variable "location" {
  required = true
}

variable "tags" {
   type        = map(string)

  default = {
    owner = "jcroth"
    project = "testing"
  }
}

# VM Related Variables  

variable "compute_instance_count" {
  description = "Number of VM instances required"
  default = 1
}


variable "compute_boot_volume_size_in_gb" {
  description = "Boot volume size of jumpbox instance"
  default     = 128
}

variable "enable_accelerated_networking" {
  default = "false"
}

variable "boot_diag_SA_endpoint" {
  default = "0"
}

variable "vm_size" {
  default = "Standard_D2_V2"
}

variable "os_offer" {
  default = "WindowsServer"
}

variable "os_publisher" {
  default = "MicrosoftWindowsServer"
}

variable "os_sku" {
  default = "2019-Datacenter"
}

variable "os_version" {
  default = "latest"
}

variable "admin_username" {
  default = "sysadmin"
}

variable "admin_password" {
  required = true
}

variable "storage_account_type" {
  default = "Standard_LRS"
}