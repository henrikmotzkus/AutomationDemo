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

using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

########################################################
#
#     Request format
#     // HTTP GET - https://azuredeployfunction.azurewebsites.net/v1//details?name=${name}
##
#     Response format 
#     {"resource_type": "${resource_type}", "region": "${region}"}



# Write to the Azure Functions log stream.
Write-Host "Request for details received"

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $env) {
    $env = $Request.Body.Name
}

try {

    # Array of resource types
    $type = @("VM", "Storage", "Network")
    
    # Generate a random 
    $rnd = get-random -minimum -1 -maximum 5

    # Create a object 
    $obj = New-Object -TypeName psobject

        
    # When caller wants a name for a prod system 
    $obj | Add-Member -MemberType NoteProperty -Name name -Value $type[$rnd]
    $obj | Add-Member -MemberType NoteProperty -Name Region -Value "westeurope"

    $body = $obj
    Write-Host "Host name for prod host " $body

} catch {

    $body = "Something went wrong"

}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
