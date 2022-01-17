# Here you define the sensible account secrets

function Set-AzureEnv {
    param (
    )
    

    $subscriptionid = <YOUR subscription ID>
    Connect-AzAccount
    Set-AzContext $subscriptionid
    $Env:GITHUB_TOKEN= <YOUR GITHUB TOKEN>


}

Export-ModuleMember -Function Set-AzureEnv