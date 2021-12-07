###############################################
#
#   Use case: Terraform requests a system name for a prod or test environment 
#   that can be used as name for the VM that is beeing deployed. 
#
#   This API is used by a custom Terraform provider 
#
#   This API take a parameter of type string and gives back a string
#   This is a demo API for tutorial step 12
#   Please provide a parameter named "env" set to either "prod" or "test"
#   
#


using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

########################################################
#
#     // HTTP GET - https://azuredeployfunction.azurewebsites.net/api/resourcename?env=$env

# Write to the Azure Functions log stream.
Write-Host "Request for resourcename received"

# Interact with query parameters or the body of the request.
$env = $Request.Query.Env
if (-not $env) {
    $env = $Request.Body.Env
}

# Getting the API version from the URL
$apiversion = $Request.Url


try {

    # Setting an array of random strings for the test system names
    $test = @("TSTSRVWIN01", "TSTSRVWIN02", "TSTSRVWIN03", "TSTSRVWIN04", "TSTSRVWIN05")
    
    # Setting an array of random strings for the prod system names
    $prod = @("PRDSRVWIN01", "PRDSRVWIN02", "PRDSRVWIN03", "PRDSRVWIN04", "PRDSRVWIN05")

    # Generate a random 
    $rnd = get-random -minimum -1 -maximum 5

    
    if ($env -eq "Test") {
        
        # When caller wants a name for a test system
        $body = $test[$rnd]
        Write-Host "Host name for test host " $body

    } else {
        
        # When caller wants a name for a prod system 
        $body = $prod[$rnd]
        Write-Host "Host name for prod host " $body

    }

} catch {

    $body = "Something went wrong"

}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
