<#
    Subscription vending script
    This script creates a workload subsription into a governed Landingszone 
#>

# Login to the AD Tenant and set the default deployment subscription
$username = "ea-accout-admin@henrikmotzkuse5.onmicrosoft.com"
Logout-AzAccount
Login-AzAccount -Tenant "6d5f51c7-0ab4-4284-bfe2-4de74c81f332"
Get-AzSubscription


# Installs the powershell graph module
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module Microsoft.Graph -Scope CurrentUser
Get-InstalledModule Microsoft.Graph


# Creates a security group in AAD tenant
Connect-MgGraph
$groupdisplayname = "AZR-SUB-IT-ANP_DWH-DEV2"
$principalid = get-mggroup -Filter "DisplayName eq '$groupdisplayname'"
if ($principalid) {
  echo "Group already existing"
}else {
  $principalid = new-mggroup -displayname $groupdisplayname -mailenabled:$false -MailNickName $groupdisplayname -SecurityEnabled
}
$principalid.id

<# 
    Creates the Azure resources
    The subscription will inherit the policies and roles 
#>

function Deploy-ARM {
  param (
  )
    $deploymentname = [DateTime]::UtcNow.ToString('yyMMdd-hhmm')
    $projectprefix = "DM3XF"
    $deploymentnameprefix = $deploymentname + "-" + $projectprefix
    $deploymentnameprefix
    New-AzManagementGroupDeployment `
      -Location "westeurope" `
      -TemplateFile ".\azuredeploy.json" `
      -TemplateParameterFile ".\azuredeploy.parameters.json" `
      -ManagementGroupId "BigBudget" `
      -principalid $principalid.id `
      -deploymentnameprefix $deploymentnameprefix `
      -name $deploymentnameprefix `
      -projectprefix $projectprefix
}  

cd .\26_Subscription_Vending\ARM
Deploy-ARM