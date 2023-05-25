$username = "ea-accout-admin@henrikmotzkuse5.onmicrosoft.com"

Logout-AzAccount
Login-AzAccount -Tenant "6d5f51c7-0ab4-4284-bfe2-4de74c81f332"

Get-AzSubscription

New-AzManagementGroupDeployment `
  -Name SubCreation `
  -Location "westeurope" `
  -TemplateFile ".\3_azuredeploy.json" `
  -TemplateParameterFile ".\3_azuredeploy.parameters.json" `
  -ManagementGroupId "BigBudget"

 