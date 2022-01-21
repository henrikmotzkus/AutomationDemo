<###########################################################
    Author: Henrik Motzkus
    Date: 11/2021
    Description: This is a demo for all the apsects of automating Azure.
    <https://github.com/henrikmotzkus/AutomationDemo>
#>

<#
    Requirements: 
        AZ Module 6.0 
        Powershell 7
        Latest Azure CLI

    Make sure to always update to the latest modules and runtimes.
#>


<###########################################################

  Step 0: Connect with Azure and set defaults

#>

$location = "westeurope"

$PSVersionTable.PSVersion

# This PS module sets the stage for Azure and logs in
Import-Module .\env.psm1
Set-AzureEnv




<###########################################################

    Folder prefix 1. Deployment on different scopes
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
       

<###########################################################
    Folder prefix 2: Deployment on resource group scope. 
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
    

<###########################################################

    Folder prefix 3: Deployment on ResourceGroup AND Subscription scope 

    - With a nested template
    - Inline in the script
    - Using the keyvault as secret store 

#>

New-AzSubscriptionDeployment `
    -TemplateFile '.\3_SubscriptionNested\azuredeploy.json' `
    -TemplateParameterFile '.\3_SubscriptionNested\azuredeploy.parameters.json' `
    -Location $location
      

<###########################################################

    Folder prefix 4: Deployment of an ARM templates via REST API. 

    - Get the url from the Azure function first 
    - Beforehand you need to deploy the deployment runner function 
    - Handing over parameter via Powershell deoloyment 
    - Github Action pipeline for deployng the function code to the funtion

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
    
# Manuall set System assigned identity in the Azure function

Invoke-WebRequest -Uri "https://azuredeployfunction.azurewebsites.net/deploy?name=TESTUEBERURL"

<###########################################################

    Folder prefix 5: Deployment with own UI definition
    
#>

# How to construct this URL
# You need Azure, the deployment scipt and UI definition
# Url need to be encoded

https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2F5_UIDef%2Fazuredeploy.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2F5_UIDef%2FUIDefRG.json


<###########################################################

    Folder prefix 6: Azure Dev Test Labs
    
#>

# Deploy ARM template to your Azure subscription
Set-AzureEnv
$rgname = "MyDevTestLab"
New-AzResourceGroup -Name $rgname -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $rgname `
    -TemplateFile '.\6_DevTestLabs\azuredeploy.json' `
    -TemplateParameterFile '.\6_DevTestLabs\azuredeploy.parameters.json'
    -pat $PAT




<###########################################################

    Folder prefix 7: Managed Application Demo
    Look: https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/
#>

# TODO

<###########################################################

    Folder prefix 8: Deploy of a blueprint out of a ARM template.
    Than manual assigment in the portal

#>

New-AzSubscriptionDeployment `
  -Name demoDeployment `
  -Location $location `
  -TemplateFile .\8_Blueprints\DeployBlueprint\azuredeploy.json `
  -blueprintName "TestBlueprint"


<###########################################################

    Folder prefix 9: Deployment of a VM to a resource group and a (Custom Script Extension )
    - With a linked template

#>

$rgname = "DeployVMandCSE5"
$location = "westeurope"
New-AzResourceGroup -Name $rgname -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $rgname `
    -TemplateUri "https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/9_CSEandDSC/azuredeploy.json" `
    -TemplateParameterUri "https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/9_CSEandDSC/azuredeploy.parameters.json"



<###########################################################

    Folder prefix 10: Deploy a Template Spec

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


<###########################################################

    Folder prefix 11: Managed Application (Service Catalog)

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


<###########################################################

   Folder prefix 12: Deploy with Terraform

#>

################################
# Deploy a resource group 
# Install Azure CLI on your workstation
# Install terraform on your workstation


cd .\12_Terraform
az login
az account set --subscription $subscriptionid
terraform init
terraform validate
terraform plan
terraform apply

###############################
# Deploy a VM with AD domain join
# Reference: https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples
# This script consists of modules

cd .\12_Terraform_ADJoin
terraform init
terraform validate
terraform plan
terraform apply

###############################
# Writing an own Terraform provider
# Tutorial: https://boxboat.com/2020/02/04/writing-a-custom-terraform-provider/
# First you need to build the binary on your windows PC.

1. Delete the folder .terraform\plugins
2. set TF_LOG=TRACE
3. go build -o terraform-provider-cmdb_v1.0.0
4. del terraform-provider-cmdb_v1.0.0.exe
5. rename terraform-provider-cmdb_v1.0.0 terraform-provider-cmdb_v1.0.0.exe
6. copy terraform-provider-cmdb_v1.0.0.exe C:\Users\<your user profile directory>\AppData\Roaming\terraform.d\plugins\registry.terraform.io\hashicorp\cmdb\1.0.0\windows_amd64\
7. del .terraform.lock.hcl
8. terraform init
9. terraform plan

###############################
# Deploy Gaia on Azure
# Documentation: https://docs.gaia-app.io/
# Deploy a AKS cluster in Azure

$resourcegroup = "GaiaApp"
$location = "westeurope"
$clusterName = "GaiaApp"

az login
az account set --subscription $subscriptionid
az group create --resource-group $resourcegroup --location $location
az aks create --resource-group $resourcegroup --name $clusterName --node-count 1 --enable-addons monitoring --generate-ssh-keys
az aks get-credentials --resource-group $resourcegroup --name $clusterName
kubectl get nodes

# Roll out the yaml on the new cluster

cd ./12_Terraform_Gaia
kubectl apply -f gaia.yaml
kubectl delete deployment gaiaapp
kubectl delete deployment mongo
kubectl delete deployment runner
kubectl delete service gaiaapplb
kubectl delete service gaiaapp

# The login to your public service



###############################
# Deploy a TF with Guthub Actions to Azure
# Documentation: https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli


### 1. Initially we need to deploy all the basic infra. Here we go with, you guessed right, Terraform!

# Log into Azure and select a subscription where you will deploy resources
az login
az account set --s $subscriptionid

# Go into the remote setup directory
cd .\12_TerraformWithGithubActions\Setup

# Initialize and apply the code
# If you use a different repository name, you'll need to specify -var=github_repository=NAME_OF_YOUR_REPO
terraform init
terraform apply






<###########################################################

    Step 13 Github Actions

#>



# Install-Module -Name PowerShellForGitHub
# Manual work

# git push




<###########################################################

    Step 14 Deployment with Azure DevOps

#>

$PSVersionTable.PSVersion
<###########################################################

    Step 15 What is the Azure Team Cloud?

#>

az --version 
az upgrade
az extension add --source https://github.com/microsoft/TeamCloud/releases/latest/download/tc-0.4.1-py2.py3-none-any.whl -y




<###########################################################

    Step 16: Enterprise Scale landing zone demo
    Look: https://github.com/Azure/Enterprise-Scale

#>
  

<###########################################################

    Step 17 Roll out Azure automanage

#>