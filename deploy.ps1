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
    
   


