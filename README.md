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

Clone the repository to your local workstation. Open it with Visual Studio Code. Every step is scripted with powershell. Open deploy.ps1 every step will be rolled out with the script. Change your the subscription id 


# 5. Contact
henrik.motzkus@microsoft.com

# 6. Status
This is work in progress and infinitely evolving 

# 7. Demo instructions

A chapter that has a reference to the deploy-script is marked with the step.

## 7.1 Basics

These are basic technologies to get a basic understanding of how the most underlying technologies works

### 7.1.1 (Step 1) Deployment of an ARM Template on different scopes 

A deployment scope is the place where the deployment is running and placing the resources your're about to deploy in Azure.

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-resource-group?tabs=azure-cli

Deployments:    
1. Deployment on Subscription scope
1. Deployment on Tenant scope


### 7.1.2 (Step 2) Deployment on an ARM Template on the resource group level

This deployment deploys a VM on the resource group scope. The VM password is securely stored in a kevault and not hardcoded in the script. First you need to deploy that keyvault and its secret. And it shows a different method of parameter handling. 

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter?tabs=azure-cli

Deployments: 
1. Deploys a keyvault
1. Deploy a VM
    
### 7.1.3 (Step 3) Deployment of a nested ARM template

This deployment shows a combined deployment that is beeing rolled out on different scopes at the same time. And it shows that this can be achieved with a nested ARM script

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates?tabs=azure-powershell

Deployments:
1. Deployment on subscription level
    
## Advanced features of Azure

These features use the basics and extends the basic layers with more functionality.

### 7.2.1 (Step 4) Deployment of a script with a deployment runner like Azure function. This Azure function can deploy a ARM script

    1. Shows a Github Action to deploy Function Code to the Azure Function
    1. This shows that you can create a public REST API for template deployment
    

### 7.2.2 (Step 5) UI Hack

    1. This steps shows how to create custom UIs for user self service deployments
    1. A central unit can provide predefined deployment workflows
    

    
### 7.2.3 (Step 7) Managed application showcase

    1. This is a demonstration of how a central unit can provide managed apps
    1. A managed app is a app where the customer is only consuming it. And not managing it.
    
### 7.2.4 (Step 8) Deploy a blueprint

    1. A blueprint can be provided by a central unit
    1. A customer can leverage the blueprint
    
### 7.2.5 (Step 9) Deployment of a Custom script Extension 

    1. Shows a Linked template 
    1. Shows Dependencies
    1. Shows the CSE
    
### 7.2.6 (Step 10) Deployment of a template spec

    1. Shows the template spec
    1. Shows Sharing in the whole enterprise
    1. Shows Modularization
    1. Shows the use of own UIs in the portal in order to create a perfect user experience
    
### 7.2.7 (Step 11) Deployment of a Managed App out of a service catalog

    1. This is a demonstration of how a central unit can provide managed apps
    1. A managed app is a app where the customer is only consuming it. And not managing it.
    1. Managed apps are protected IP of the central unit.
    
## 7.3 Other tools and frameworks

### 7.3.1 Enterprise Scale Landing Zone Showcase

    1. This is a comprehensive showcase of deploying an ARM template that is complex

### 7.3.2 (Step 12) Deployment with Terraform

    1. This deploys a small terraform script

### 7.3.3 (Step 13) Deployment with Github Actions

    TODO

### 7.3.4 (Step 14) Deployment with Azure DevOps

    TODO

### 7.3.5 (Step 15) The Azure TeamCloud

    TODO

### 7.3.6 (Step 16) Azure DevTestLabs

    TODO
