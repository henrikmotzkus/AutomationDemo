<#
  Mit Azure Verbinden und Subscription setzen
#>
$location = "westeurope"
$subscriptionid = "2abc2ec1-2238-430d-bf52-40cb7dc8b652"
Connect-AzAccount
Set-AzContext $subscriptionid



<#
    Deployment auf Subscription Ebene
#>
$subrgname = "Deplytosubscription"
New-AzSubscriptionDeployment `
    -Name $subrgname `
    -Location $location `
    -TemplateFile ".\Subscription\azuredeploy.json"


<#
    Deployment auf ResourceGroup Ebene. Deployt eine VM mit Reference auf einen Keyvault.
    With conditional varaiables
#>
New-AzResourceGroup -Name "Keyvault" -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName "Keyvault" `
    -TemplateFile '.\Keyvault\azuredeploy.json' `
    -adUseriD '49c9b64d-6d4c-4da0-a501-a0d701e1fdf4'

$deployrgname = "DeploytoRG"
New-AzResourceGroupDeployment `
    -ResourceGroupName $deployrgname `
    -TemplateFile '.\ResourceGroup\azuredeploy.json' `
    -TemplateParameterFile '.\ResourceGroup\azuredeploy.parameters.json'
    

<#
    Deployment auf ResourceGroup UND Subscription Ebene mit einem nested Template. Inline
    Nutzung von Keyvault als Passwort Speicher
#>
New-AzSubscriptionDeployment `
    -TemplateFile '.\SubscriptionNested\azuredeploy.json' `
    -TemplateParameterFile '.\SubscriptionNested\azuredeploy.parameters.json' `
    -Location $location
      

<#
    Deployment eines Templates über eine individuelle REST API. Die Url ist in der Function ersichtlich. 
    Vorher muss erst die Function angelegt werden.
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
    Deployment über eine eigene UI Definition und automatisch Übergabe ans Azure Portal
    Vorsicht dieses Feature ist nahezu undokumentiert!
#>
https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2FUIDef%2Fazuredeploy.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2FUIDef%2FUIDefRG.json
PasswordPassword_

<#
    Enterprise Scale landing zone Demo
    Look: https://github.com/Azure/Enterprise-Scale
#>


<# 
    Managed Application Demo
    Look: https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/
#>
# TODO

<#
    Deploy of a blueprint out of a ARM template.
    Than manual assigment
#>
New-AzSubscriptionDeployment `
  -Name demoDeployment `
  -Location $location `
  -TemplateFile .\Blueprints\DeployBlueprint\azuredeploy.json `
  -blueprintName "TestBlueprint"


<#
    Deployment of a VM to a resource group and a (Custom Script Extension )
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
    Deploy a Template Specs
#>