# ESLZTFPipelining

- Create Service Principal Account
```
    New-AzADServicePrincipal -DisplayName ESLZAccount -Scope "/" -Role Owner
```
- Grant Access to MG "/" path
```
    #sign in to Azure from Powershell, this will redirect you to a webbrowser for authentication, if required
    Connect-AzAccount

    #get object Id of the current user (that is used above)
    $spn = Get-AzADServicePrincipal -DisplayName ESLZAccount

    #assign Owner role to Tenant root scope ("/") as a User Access Administrator
    New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $spn.Id
```