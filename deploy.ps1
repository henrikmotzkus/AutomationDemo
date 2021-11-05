<#
    Author: Henrik Motzkus
    Date: 11/2021
    Description: This is a demo for all the apsects of automating Azure.
#>

<#
    Requirements: AZ Module 6.0 and Powershell 7
#>


<#
  Mit Azure Verbinden und Subscription setzen
#>
$location = "westeurope"

# Internal
$subscriptionid = "2abc2ec1-2238-430d-bf52-40cb7dc8b652"

# Visual Studio MCT
$subscriptionid = "1f6dba4f-8ad7-40d1-a562-6d78365dc81e"

Connect-AzAccount
Set-AzContext $subscriptionid

<#
    Step 1. Deployment auf Subscription Ebene
#>
$subrgname = "AAAAAAAAAAAA"
New-AzSubscriptionDeployment `
    -Name $subrgname `
    -Location $location `
    -TemplateFile ".\Subscription\azuredeploy.json" `
    -ResourceGroupName $subrgname


<#
    Step 2: Deployment auf ResourceGroup Ebene. Deployt eine VM mit Reference auf einen Keyvault.
    - With conditional varaiables
#>
New-AzResourceGroup -Name "Keyvault2" -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName "Keyvault2" `
    -TemplateFile '.\Keyvault\azuredeploy.json' `
    -adUseriD '49c9b64d-6d4c-4da0-a501-a0d701e1fdf4'

$deployrgname = "DeploytoRG2"
New-AzResourceGroup -Name $deployrgname -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $deployrgname `
    -TemplateFile '.\ResourceGroup\azuredeploy.json' `
    -TemplateParameterFile '.\ResourceGroup\azuredeploy.parameters.json'
    

<#
    Step 3. Deployment auf ResourceGroup UND Subscription Ebene mit einem nested Template. 
    - Inline
    - Nutzung von Keyvault als Passwort Speicher
#>

New-AzSubscriptionDeployment `
    -TemplateFile '.\SubscriptionNested\azuredeploy.json' `
    -TemplateParameterFile '.\SubscriptionNested\azuredeploy.parameters.json' `
    -Location $location
      

<#
    Step 4: Deployment eines Templates über eine individuelle REST API. Die Url ist in der Function ersichtlich. 
    - Vorher muss erst die Function angelegt werden
    - Übergabe der Deployment Parameter per PSBefehl
    - Github Action pipeline für den function code
#>
$funcrgname = "DeployFunction"
New-AzResourceGroup -Name $funcrgname -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $funcrgname `
    -TemplateFile '.\Function\azuredeploy.json' `
    -subscriptionId $subscriptionid `
    -FunctionName "AzureDeployFunction" `
    -location $location `
    -serverFarmResourceGroup $funcrgname
    
# Manuell System assigned identity setzen

Invoke-WebRequest -Uri "https://azuredeployfunction.azurewebsites.net/api/deploy?name=TESTUEBERURL"

<#
    Step 5: Deployment über eine eigene UI Definition und automatisch Übergabe ans Azure Portal
    Vorsicht dieses Feature ist nahezu undokumentiert!
#>
https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2FUIDef%2Fazuredeploy.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2FUIDef%2FUIDefRG.json
PasswordPassword_

<#
    Step 6: Enterprise Scale landing zone Demo
    Look: https://github.com/Azure/Enterprise-Scale
#>


<# 
    Step 7: Managed Application Demo
    Look: https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/
#>
# TODO

<#
    Step 8: Deploy of a blueprint out of a ARM template.
    Than manual assigment
#>
New-AzSubscriptionDeployment `
  -Name demoDeployment `
  -Location $location `
  -TemplateFile .\Blueprints\DeployBlueprint\azuredeploy.json `
  -blueprintName "TestBlueprint"


<#
    Step 9: Deployment of a VM to a resource group and a (Custom Script Extension )
    With a linked template
#>
$rgname = "DeployVMandCSE5"
$location = "westeurope"
New-AzResourceGroup -Name $rgname -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $rgname `
    -TemplateUri "https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/CSEandDSC/azuredeploy.json" `
    -TemplateParameterUri "https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/CSEandDSC/azuredeploy.parameters.json"



<#
    Step 10: Deploy a Template Specs
#>

# Plain template
$name = "SimpleVM"
$rgname = "Specs"
$templatefile = ".\ResourceGroup\azuredeploy.json"
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
$templatefile = ".\TemplateSpecs\azuredeploy.json"
$Version = "2.0"
New-AzTemplateSpec -Name $name `
    -Version $Version `
    -ResourceGroupName $rgname `
    -Location $location `
    -TemplateFile $templatefile `
    -UIFormDefinitionFile ".\TemplateSpecs\UIDefRG.json"

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
  -File ".\ManagedApplication\app.zip" `
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