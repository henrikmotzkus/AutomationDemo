<#
    Author: Henrik Motzkus
    Date: 11/2021
    Description: This is a demo for all the apsects of automating Azure.
#>

<#
    Requirements: AZ Module 6.0 and Powershell 7
#>


<#
  Step 0: Connect with Azure and set defaults
#>
$location = "westeurope"

# Internal
$subscriptionid = "2abc2ec1-2238-430d-bf52-40cb7dc8b652"

# Visual Studio MCT
$subscriptionid = "1f6dba4f-8ad7-40d1-a562-6d78365dc81e"

Connect-AzAccount
Set-AzContext $subscriptionid

<#
    Step 1. Deployment on different scopes
#>

# Subscription scope
# This deploys a resourcegroup on a subscription scope

$subrgname = "AAAAAAAAAAAA"
New-AzSubscriptionDeployment `
    -Name $subrgname `
    -Location $location `
    -TemplateFile ".\1_Subscription\azuredeploy.json" `
    -ResourceGroupName $subrgname

# Tenant scope
# This deploys a new subscription in the tenant

New-AzTenantDeployment `
    -TemplateFile ".\1_SubscriptionCreation\azuredeploy.json"
    -TemplateParameterFile ".\1_SubscriptionCreation\azuredeploy.parameters.json"
       

<#
    Step 2: Deployment on resource group scope. 
    - Deploys a VM with a secret from a keyvault
    - With conditional variables
#>


New-AzResourceGroup -Name "Keyvault2" -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName "Keyvault2" `
    -TemplateFile '.\2_Keyvault\azuredeploy.json' `
    -adUseriD '49c9b64d-6d4c-4da0-a501-a0d701e1fdf4'

$deployrgname = "DeploytoRG2"
New-AzResourceGroup -Name $deployrgname -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $deployrgname `
    -TemplateFile '.\2_ResourceGroup\azuredeploy.json' `
    -TemplateParameterFile '.\2_ResourceGroup\azuredeploy.parameters.json'
    

<#
    Step 3. Deployment on ResourceGroup AND Subscription scope 
    - With a nested template
    - Inline in the script
    - Using the keyvault as secret store 
#>

New-AzSubscriptionDeployment `
    -TemplateFile '.\3_SubscriptionNested\azuredeploy.json' `
    -TemplateParameterFile '.\3_SubscriptionNested\azuredeploy.parameters.json' `
    -Location $location
      

<#
    Step 4: Deployment of an ARM templates via REST API. 
    - Get the url from the Azure function first 
    - Beforehand you need to deploy deplyoment runner function 
    - Handing over parameter vi Powershell dpeloyment 
    - Github Action pipeline for deploing the function code to the funtion
#>
$funcrgname = "DeployFunction"
New-AzResourceGroup -Name $funcrgname -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $funcrgname `
    -TemplateFile '.\4_Function\azuredeploy.json' `
    -subscriptionId $subscriptionid `
    -FunctionName "AzureDeployFunction" `
    -location $location `
    -serverFarmResourceGroup $funcrgname
    
# Manuell System assigned identity setzen

Invoke-WebRequest -Uri "https://azuredeployfunction.azurewebsites.net/api/deploy?name=TESTUEBERURL"

<#
    Step 5: Deployment with own UI definition
    
#>
# How to construc this URL
# You need Azure, the deployment scipt and UI definition
# Url need to be encoded

https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2F5_UIDef%2Fazuredeploy.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2F5_UIDef%2FUIDefRG.json


<# 
    Step 6: Azure Dev Test Labs
    
#>

#   TODO

<# 
    Step 7: Managed Application Demo
    Look: https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/
#>

# TODO

<#
    Step 8: Deploy of a blueprint out of a ARM template.
    Than manual assigment in the portal
#>
New-AzSubscriptionDeployment `
  -Name demoDeployment `
  -Location $location `
  -TemplateFile .\8_Blueprints\DeployBlueprint\azuredeploy.json `
  -blueprintName "TestBlueprint"


<#
    Step 9: Deployment of a VM to a resource group and a (Custom Script Extension )
    - With a linked template
#>
$rgname = "DeployVMandCSE5"
$location = "westeurope"
New-AzResourceGroup -Name $rgname -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $rgname `
    -TemplateUri "https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/9_CSEandDSC/azuredeploy.json" `
    -TemplateParameterUri "https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/9_CSEandDSC/azuredeploy.parameters.json"



<#
    Step 10: Deploy a Template Spec
#>

# Plain template
$name = "SimpleVM"
$rgname = "Specs"
$templatefile = ".\2_ResourceGroup\azuredeploy.json"
$Version = "1.0"
New-AzTemplateSpec -Name $name `
    -Version $Version `
    -ResourceGroupName $rgname `
    -Location $location `
    -TemplateFile $templatefile

$templatespecid = (Get-AzTemplateSpec -name "SimpleVM" -ResourceGroupName $rgname -version $Version).Versions.Id

New-AzResourceGroupDeployment `
  -TemplateSpecId $templatespecid `
  -ResourceGroupName $rgname

# Linked Template and own UI

$name = "SimpleVMnested3"
$rgname = "Specs"
$templatefile = ".\10_TemplateSpecs\azuredeploy.json"
$Version = "2.0"
New-AzTemplateSpec -Name $name `
    -Version $Version `
    -ResourceGroupName $rgname `
    -Location $location `
    -TemplateFile $templatefile `
    -UIFormDefinitionFile ".\10_TemplateSpecs\UIDefRG.json"

$templatespecid = (Get-AzTemplateSpec -name $name -ResourceGroupName $rgname -version $Version).Versions.Id

New-AzResourceGroupDeployment `
  -TemplateSpecId $templatespecid `
  -ResourceGroupName $rgname


<#
    Step 11: Managed Application (Service Catalog)
#>

# Upload Package in an Storage Account
$margname = "ManagedApp"
$saname = "managedappsahenrik"
New-AzResourceGroup -Name $margname -Location $location

$storageAccount = New-AzStorageAccount `
  -ResourceGroupName $margname `
  -Name $saname `
  -Location $location `
  -SkuName Standard_LRS `
  -Kind StorageV2

$ctx = $storageAccount.Context

New-AzStorageContainer -Name appcontainer -Context $ctx -Permission blob

Set-AzStorageBlobContent `
  -File ".\11_ManagedApplication\app.zip" `
  -Container appcontainer `
  -Blob "app.zip" `
  -Context $ctx

 # Prepare Azure AD
$groupID=(Get-AzADGroup -DisplayName "ManagedApp").Id

$ownerID=(Get-AzRoleDefinition -Name Owner).Id

New-AzResourceGroup -Name $margname -Location $location

$blob = Get-AzStorageBlob -Container appcontainer -Blob app.zip -Context $ctx

New-AzManagedApplicationDefinition `
  -Name "ManagedAppSimpleVM" `
  -Location $location `
  -ResourceGroupName $margname `
  -LockLevel ReadOnly `
  -DisplayName "SimpleVM Enterprise Ready" `
  -Description "This is the enterprise wide standard VM template." `
  -Authorization "${groupID}:$ownerID" `
  -PackageFileUri $blob.ICloudBlob.StorageUri.PrimaryUri.AbsoluteUri


  <#
    Step 12: Deploy with Terraform
  #>

  cd .\12_Terraform

  az login

  terraform init
  terraform validate
  terraform apply

<#
    Step 13 Github Actions
#>

# Install-Module -Name PowerShellForGitHub
# Manual work

# git push


<#
    Step 14 Deployment with Azure DevOps
#>

<#
    Step 15 What is the Azure Team Cloud?
#>



<#
    Step 16: Enterprise Scale landing zone demo
    Look: https://github.com/Azure/Enterprise-Scale
#>
  

<#
    Step 17 Roll out Azure automanage
#>