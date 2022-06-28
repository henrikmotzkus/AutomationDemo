# STEP 20 Run a powershell script within an ARM template with the help of Github Actions

In case you're limited by the functionality of Azure ARM then think of using PowerShell scripts within your ARM script.

This demo shows the possibilities of using a powershell script embedded in an ARM script. 

This could be the case i. e. when you try to create a dynamic group with membership roles in AAD and assign a Azure RBAC role to it. 

Here more docs that I used.

[[DOCS for Role assignment](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-template)]

[[Loggin into Azure with Github Actions](https://www.techielass.com/create-azure-credentials-for-use-in-github-actions/)]

[[Simple Example of Deployment scripts](https://github.com/Azure/azure-docs-json-samples/blob/master/deployment-script/deploymentscript-helloworld-primaryscripturi.json)]

[[DOCS for Deployment scripts](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template)]

[[DOCS for the new Graph Powershell](https://docs.microsoft.com/en-us/powershell/microsoftgraph/get-started?view=graph-powershell-1.0)]

[[DOCS for Github Actions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions?tabs=userlevel)]
