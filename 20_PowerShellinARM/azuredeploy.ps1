param(
    [string]$DisplayName,
    [string]$Description,
    [string]$CompanyName,
    [string]$Secret
)

$appid = '6f661cdf-e77a-4f9b-9101-8cdab5446e88'
$tenantid = '6d5f51c7-0ab4-4284-bfe2-4de74c81f332'
$secret = $Secret

$body =  @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $appid
    Client_Secret = $secret
}

Write-Output $body

$DisplayName
$Description
$CompanyName
$Secret

$connection = Invoke-RestMethod `
    -Uri https://login.microsoftonline.com/$tenantid/oauth2/v2.0/token `
    -Method POST `
    -Body $body

$token = $connection.access_token

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Microsoft.Graph -Force -Scope CurrentUser
#Import-Module -Name Microsoft.Graph -Force

$token

Connect-MgGraph -AccessToken $token

$membershiprule = "(user.CompanyName -contains ""$CompanyName"")"

$membershiprule

$res = New-MgGroup -DisplayName $DisplayName `
    -Description $Description `
    -GroupTypes "DynamicMembership" `
    -membershipRule $membershiprule `
    -membershipRuleProcessingState "On" `
    -SecurityEnabled `
    -MailEnabled:$False `
    -MailNickname "group"

$output = $res.Id

Write-Output $output
$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['Id'] = $output