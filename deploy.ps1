<#
  Mit Azure Verbinden und Subscription setzen
#>

Connect-AzAccount
Set-AzContext "2abc2ec1-2238-430d-bf52-40cb7dc8b652"


<#  Diese Aktionen nur einmalig ausführen #>
<#
    KeyVault für das Adminpasswort anlegen
#>
New-AzResourceGroup -Name "Keyvault" -Location "westeurope"
New-AzResourceGroupDeployment `
    -ResourceGroupName "Keyvault" `
    -TemplateFile '.\Keyvault\azuredeploy.json' `
    -adUseriD '49c9b64d-6d4c-4da0-a501-a0d701e1fdf4'


<#
    Azure Function anlegen. Die Azure function stellt eine REST API für das Deployment von Templates bereit
#>
New-AzResourceGroup -Name "DeployFunction" -Location "westeurope"
New-AzResourceGroupDeployment `
    -ResourceGroupName "DeployFunction" `
    -TemplateFile '.\Function\azuredeploy.json' `
    -subscriptionId '2abc2ec1-2238-430d-bf52-40cb7dc8b652' `
    -FunctionName "AzureDeployFunction" `
    -location 'westeurope' `
    -serverFarmResourceGroup 'DeployFunction'
    

<#
    Deployment auf Subscription Ebene
#>
New-AzSubscriptionDeployment `
    -Name "Deployresourecgroup" `
    -Location "westeurope" `
    -TemplateFile ".\Subscription\azuredeploy.json"



<#
    Deployment auf ResourceGroup Ebene
#>
New-AzResourceGroupDeployment `
    -ResourceGroupName "TTest2" `
    -TemplateFile '.\ResourceGroup\azuredeploy.json' `
    -TemplateParameterFile '.\ResourceGroup\azuredeploy.parameters.json'
    
    
 

<#
    Deployment auf ResourceGroup und Subscription Ebene mit einem nested Template
#>
New-AzSubscriptionDeployment `
    -TemplateFile '.\SubscriptionNested\azuredeploy.json' `
    -TemplateParameterFile '.\SubscriptionNested\azuredeploy.parameters.json' `
    -Location 'westeurope'
    
   

<#
    Deployment eines Templates über eine individuelle REST API. Die Url ist in der Function ersichtlich
#>
Invoke-WebRequest -Uri "https://azuredeployfunction.azurewebsites.net/api/deploy?name=TESTUEBERURL"

<#
    Deployment über eine eigene UI Definition
#>

https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FEnterprise-Scale%2Fmain%2FeslzArm%2FeslzArm.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FEnterprise-Scale%2Fmain%2FeslzArm%2Feslz-portal.json

https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2UIDef%2Fazuredeploy.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fhenrikmotzkus%2FAutomationDemo%2Fmain%2FUIDef%2FcreateUiDefinition.json


https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/UIDef/azuredeploy.json


https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/UIDef/createUiDefinition.json



