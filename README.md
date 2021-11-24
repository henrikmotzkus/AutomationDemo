# 1. Azure Automation Demo tl;dr
This is a tutorial to try out many aspects of automating Azure management tasks. The deploy.ps1 is the command center to roll out all demo steps.

# 2. Problem statement
In huge environments (i. e. a world wide company) automation in the IT is KEY. Automation enables efficiency and fast development cycles. Cloud is an enabler technology. Azure has tons of technologies that could help to automate. This guide is a uncompleted and ever evolving tutorial on the automation aspect of Azure.

# 3. With this guide you learn about 

1. Deployment basics like: scopes, ARM scripts, linked templates, secret handling, custom script extensions
1. Where to store my deployment scripts
1. Building a sofisticated deployment environments with an Azure function
1. Reference to the enterprise scale landing zone
1. Use of built in management tool like: Blueprints, Managed Apps, Custom UIs
1. A little bit of terraform

# 4. How to use

Clone the repository to your local workstation. Open it with Visual Studio Code. Every step is scripted with powershell. Open deploy.ps1 every step will be rolled out with the script.  


# 5. Contact
henrik.motzkus@microsoft.com

# 6. Status
This is work in progress and infinitely evolving.

Disclaimer: This demo doesn't explains the concepts itself. It combines the various features and demonstrates the value. For education please visit the official documentation. 

# 7. Demo steps

Instructions:
First change your subscription ID and location in the deploy.ps1

## 7.1 Basics

These are basic technologies to get a basic understanding of how the most underlying technologies works

### 7.1.1 (Step 1) Deployment of an ARM Template on different scopes 

A deployment scope is the place where the deployment is running and placing the resources your're about to deploy in Azure.

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-resource-group?tabs=azure-cli

Instrunctions:    
1. Run the commands in the powershell

### 7.1.2 (Step 2) Deployment on an ARM Template on the resource group level

This deployment deploys a VM on the resource group scope. The VM password is securely stored in a kevault and not hardcoded in the script. First you need to deploy that keyvault and its secret. And it shows a different method of parameter handling. 

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter?tabs=azure-cli

Instructions:
1. Run the commands in the powershell
    
### 7.1.3 (Step 3) Deployment of a nested ARM template

This deployment shows a combined deployment that is beeing rolled out on different scopes at the same time. And it shows that this can be achieved with a nested ARM script

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates?tabs=azure-powershell

Instructions: 
1. Run the commands in the powershell
    
## 7.2 Advanced features of Azure

These features use the basics and extends the basic layers with more functionality.

### 7.2.1 (Step 4) Deployment of a script with a deployment runner like Azure function. This Azure function can deploy a ARM script

This step shows the deployment of a Azure function. The functionality of the function to run deployments in Azure. THe function code is rolled out with Github actions. In 4_FUnctionCode you'll find the code o the function.

Instructions: 
1. Run the commands in the powershell
2. Assing a 'System assigned' identity to the Azure function
3. Assign 'contributor rights' to that identity
4. Get the URL of the function
5. Call the function via REST Call 
    

### 7.2.2 (Step 5) Own UI definitions

Arm templates need to ingest parameters. With a UI defintion you're able to create beautiful UIs on Azure to customize the customer experience. Especially on big companies a lot of information needs to be incorporated at the time of deployment. 

As a central unit you can provide custom scripts.

Instructions:
1. Call the WebUrl in the deploy.ps1

### 7.2.3 (Step 6) Azure DevTestLabs

A DevTestLab in Azure is a currated environment where you as a central uni can offer your customers cloud environments. 

More: https://docs.microsoft.com/en-us/azure/devtest-labs/devtest-lab-overview

Instructions:    

 TODO
    
### 7.2.3 (Step 7) Managed applications
A managed app is a offering you can make on the Azure marketplace. 

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/overview

Instructions: 

    TODO
    
### 7.2.4 (Step 8) Deploy a blueprint
With blueprints a central unit can provide ARM templates, assigned policies, assign roles, and assigned management groups as a UNIT. A "customer" can use the blueprint in order to roll out that blueprint.

More: https://docs.microsoft.com/en-us/azure/governance/blueprints/

Instructions: 
1. Run the commands in the powershell. 
1. Go to the portal an assign the blueprint manually
    
### 7.2.5 (Step 9) Deployment of a Custom script Extension
This deploys a VM from step 2. And sthe a custom scription extension into the VM.

More: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows

Instructions: 
1. Run the commands in the powershell


### 7.2.6 (Step 10) Deployment of a template spec
This uploads a template Spec to Azure and deploys it then. A template spec can be used to modularize the ARM template and share it in the whole company. This demo uses the script from step 2. And it uses a nested template out of step 10. You can provide a own UI definition.

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell


Instructions:
1. Run the commands in the powershell.
2. GO to the portal an use the template spec there
    
### 7.2.7 (Step 11) Deployment of a Managed App out of a service catalog
This uploads a managed app to the service catalog of a Azure environment. 

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/deploy-service-catalog-quickstart
 
Instructions: 
1. Run the commands in the powershell
2. Go to the portal and deploy a app out of the service catalog
    
## 7.3 Other tools and frameworks
New we're entering the world of additional tools and frameworks that deliver more value and help to automate Azure management tasks as much as possible.

### 7.3.1 Enterprise Scale Landing Zone Showcase
This is a comprehensive showcase of deploying an ARM template that is complex

More: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/architecture

Instructions:


### 7.3.2 (Step 12) Deployment with Terraform
This deploys a small terraform script

More: https://docs.microsoft.com/en-us/azure/developer/terraform/

Instructions:

### 7.3.3 (Step 13) Deployment with Github Actions
In step 4 you deployed a Azure function. The code deployment onto the Azure function is achieved with Github actions. In \.github\workflows you'll find a workflow to deploy code from Github to the function. 

More: 

Instructions: 

    TODO
    Blah
    Böah

### 7.3.4 (Step 14) Deployment with Azure DevOps


More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/add-template-to-azure-pipelines

TODO

### 7.3.5 (Step 15) The Azure TeamCloud

More: https://github.com/microsoft/TeamCloud


### 7.3.6 

    TODO
