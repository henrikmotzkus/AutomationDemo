param([string] $DisplayName,
              [string] $Description,
              [string] $CompanyName
            )

$appid = '6f661cdf-e77a-4f9b-9101-8cdab5446e88'
$tenantid = '6d5f51c7-0ab4-4284-bfe2-4de74c81f332'
$secret = ''

$body =  @{
    Grant_Type    = \"client_credentials\"
    Scope         = \"https://graph.microsoft.com/.default\"
    Client_Id     = $appid
    Client_Secret = $secret
}

$connection = Invoke-RestMethod `
    -Uri https://login.microsoftonline.com/$tenantid/oauth2/v2.0/token `
    -Method POST `
    -Body $body

$token = $connection.access_token

Install-Module -Name Microsoft.Graph -Force
Import-Module -Name Microsoft.Graph -Force

Connect-MgGraph -Scopes \"User.Read.All\",\"Group.ReadWrite.All\" -AccessToken $token

New-MgGroup -DisplayName $DisplayName -Description $Description -GroupTypes \"DynamicMembership\" -membershipRule \"(user.CompanyName -contains $CompanyName)\" -membershipRuleProcessingState \"On\" -SecurityEnabled -MailEnabled:$False -MailNickname \"group\"

$output = \"Group {0} created\" -f $DisplayName
Write-Output $output
$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['text'] = $output