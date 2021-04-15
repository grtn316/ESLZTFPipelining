# Enterprise Scale Landing Zones Terraform Example Using Github Actions

Please refer to the repo [terraform-azurerm-caf-enterprise-scale](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale) for examples and input parameters for the Terraform variables file.

In this sample, we have several pipelines deploying the following:
1. The base ESLZ environment:
   - Management Groups
   - Landing Zones
   - Policies
   - Policy Sets
   - Policy Assignments
   - Role Assignments
2. A base network inside of the connectivity subscription:
   - Virtual Machine
   - Virtual Network
   - Network Security Groups
3. A simple AKS deployment inside of a landing zone:
   - Azure Kubernetes Service
   - Virtual Network (with peering to connectivity VNet)
   - Network Security Group

# Getting Started

For the intial deployment of ESLZ, you will need to create a service principal and grant it access to the root management group scope. *We strongly recommend developing a process to allow temporary access for your deployments and not leave accounts with standing access at the root level.*

## 1. Elevate Access to manage Azure resources in the directory

1.1 Sign in to the Azure portal or the Azure Active Directory admin center as a Global Administrator. If you are using Azure AD Privileged Identity Management, activate your Global Administrator role assignment.

1.2 Open Azure Active Directory.

1.3 Under _Manage_, select _Properties_.
![alt](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/elevate-access-global-admin/azure-active-directory-properties.png)

1.4 Under _Access management for Azure resources_, set the toggle to Yes.

![alt](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/elevate-access-global-admin/aad-properties-global-admin-setting.png)

## 2. Grant Access to your Service Principal at root scope "/" to deploy Enterprise-Scale reference implementation

Please ensure you are logged in as a user with UAA role enabled in AAD tenant and logged in user is not a guest user.


PowerShell

- Create Service Principal Account
    ```powershell
        #sign in to Azure from Powershell, this will redirect you to a webbrowser for authentication, if required
        Connect-AzAccount

        #create a new service principal with root level owner access.
        New-AzADServicePrincipal -DisplayName ESLZAccount -Scope "/" -Role Owner
    ```
- Grant Access to MG "/" path
    ```powershell
        #sign in to Azure from Powershell, this will redirect you to a webbrowser for authentication, if required
        Connect-AzAccount

        #get object Id of the current user (that is used above)
        $spn = Get-AzADServicePrincipal -DisplayName ESLZAccount

        #assign Owner role to Tenant root scope ("/") as a User Access Administrator
        New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $spn.Id
    ```

Please note, it may take up to 15-30 minutes for permission to propagate at tenant root scope. It is highly recommended that you log out and log back in.

### Creating a scoped role assignment

The Owner privileged root tenant scope *is required* in the deployment of the [Reference implementation](EnterpriseScale-Deploy-reference-implentations.md).  However post deployment, and as your use of Enterprise Scale matures, you are able to limit the scope of the Service Principal Role Assignment to a subsection of the Management Group hierarchy.
Eg. `"/providers/Microsoft.Management/managementGroups/YourMgGroup"`.


## Other helpful commands
- List Current Role Assignments for MG "/" path
    ```powershell
        #sign in to Azure from Powershell, this will redirect you to a webbrowser for authentication, if required
        Connect-AzAccount

        #get list of owner assignements on the root scope
        Get-AzRoleAssignment | where {$_.RoleDefinitionName -eq "Owner" -and $_.Scope -eq "/"}
    ```
- Remove Current Role Assignments for MG "/" path
    ```powershell
        #sign in to Azure from Powershell, this will redirect you to a webbrowser for authentication, if required
        Connect-AzAccount

        #Remove Role Assignment using SPN Name
        Remove-AzRoleAssignment -ServicePrincipalName ESLZAccount -RoleDefinitionName "Owner" -Scope "/"
        #Remove Role Assignment using Object Id
        Remove-AzRoleAssignment -ObjectId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -RoleDefinitionName "Owner" -Scope "/"
    ```

## Next steps
You will need to create 6 secrets in your repo (Settings >  Secrets):
- **AZURE_CLIENT_ID** - This is the client ID of the service principal you created above.
- **AZURE_CLIENT_SECRET** - This is a client secret you need to create in AAD > Application Registrations for the service principal you created above.
- **AZURE_SUBSCRIPTION_ID** - This can be any subscription the service principal has access to (required by terraform to execute).
- **AZURE_TENANT_ID** - Tenant ID of your Azure environment.
- **TF_API_TOKEN** - If you are using Terraform to store state, you will need to genereate an API Token for your team.
- **VM_ADMIN_PASSWORD** - Any complex password for provisoning of your VM.

Please proceed with pipeline deployments:
1. [Platform Deploy](./.github/workflows/platformdeploy.yml)
    - Optional Variables
      - Management group prefix (defaults to "es")
      - Map Subscriptions to Management Groups
        ```
            {
                root           = [],
                decommissioned = [],
                sandboxes      = [],
                landing-zones  = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"],
                platform       = [],
                connectivity   = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"],
                management     = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"],
                identity       = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
            }
        ```
2. [Network Deploy](./.github/workflows/networkdeploy.yml)
    - Required Variables
      - Connectivity Subscription ID
    - Optional Variables
      - Deployment Region (Defaults to "eastus")
      - Virtual Machine Admin Username (Defaults to "sysadmin")
3. [AKS Deploy](./.github/workflows/aksdeploy.yml)
   - Required Variables
      - Landing Zone Subscription ID