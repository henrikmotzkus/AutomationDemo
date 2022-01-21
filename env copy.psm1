# Here you define the sensible account secrets

function Set-AzureEnv {
    param (
    )
    

    $subscriptionid = <YOUR subscription ID>
    Connect-AzAccount
    Set-AzContext $subscriptionid
    $PAT = <YOUR GITHUB TOKEN>
    $Env:GITHUB_TOKEN = $PAT


}

Export-ModuleMember -Function Set-AzureEnv