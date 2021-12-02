using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}


try {
    
    
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/1_Subscription/azuredeploy.json' -Outfile 'c:\home\azuredeploy.json'

    Write-Host "Downloaded deploy template from github"

    Disconnect-AzAccount

    Clear-AzContext -Force

    #Connect-AzAccount -Identity -tenant $env:APPSETTING_tenantid -AccountId $env:APPSETTING_AccountId

    Connect-AzAccount -Identity 
    
    Write-Host "connected to Azure"

    New-AzSubscriptionDeployment `
        -Name $name `
        -Location "westeurope" `
        -TemplateFile "c:\home\azuredeploy.json" `
        -ResourceGroupName $name

    Write-Host "Deployed template"
      
    
    $body = "Deployment was successfull"

} catch {

    $body = "Deployment was not successfull"

}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
