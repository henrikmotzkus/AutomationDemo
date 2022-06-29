# STEP 20 Run a powershell script within an ARM template with the help of Github Actions

This demo shows the possibilities of using a powershell script embedded in an ARM script.

Use case: When you try to create a dynamic group with membership roles in AAD and assign a Azure RBAC role to it ARM doesn't provides the needed features. Creating a group with dynamic memebership rules can't be created with ARM.But with powershell.

Okay now the theory. You can embedd a powershell script in an arm script with a resource of type Microsoft.Resources/deploymentScripts. This arm resource will spin up a small container in Azure where the ps script will run. Arguments will flow from the arm parameter section to the arguments section of the resource. The azuredeploy.json contains the arm script. In the arm script is a reference to a remote ps script that is hosted by a guthub repo. The azuredeploy.ps1 conains the logic. In order to spin up a complete ci/cd pipeline the file Step20_pipeline.yaml in the workflows folder contains an action workflow for guthub. Everytime a push is made to that repo main branch the pipeline will kick in.

## Instructions

1. When you want to develop a ps script You need a dev environment. Beause the ps script is running in an internal Azure container instance you need to consider some environmental restrictions. Create a dev environment with the "create_Dev_Container_Instance.ps1". Here in this code base the ps script is already ready to use. 
1. The pipeline ".github\workflows\Step20_pipeline.yaml" is the coordinator of the actuall deployment in Azure with ARM. Everytime You do a push to the main branch of your repository the pipeline will be kicked of and deploy the "azuredeploy.json" to Azure. 


## Documentation I used

[DOCS for Role assignment](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-template)

[Loggin into Azure with Github Actions](https://www.techielass.com/create-azure-credentials-for-use-in-github-actions/)

[Simple Example of Deployment scripts](https://github.com/Azure/azure-docs-json-samples/blob/master/deployment-script/deploymentscript-helloworld-primaryscripturi.json)

[DOCS for Deployment scripts](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template)

[DOCS for the new Graph Powershell](https://docs.microsoft.com/en-us/powershell/microsoftgraph/get-started?view=graph-powershell-1.0)

[DOCS for Github Actions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions?tabs=userlevel)
