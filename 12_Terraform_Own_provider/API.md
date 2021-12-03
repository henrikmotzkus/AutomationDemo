# Description of the REST API
## Test Url
https://azuredeployfunction.azurewebsites.net/api


## Request format - Retrieving a name for the VM deployment in test

HTTP GET - /resourcename?env=test

Response: $name plain text in the body

## Request format - Retrieving a name for the VM deployment in prod

HTTP GET - /resourcename?env=prod

Response: $name plain text in the body