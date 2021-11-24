# Azure Automation Demo tl;dr
This is a tutorial to try out many aspects of automating Azure management tasks. The deploy.ps1 is the command center to roll out all demo steps.

# Problem statement
In huge environments (i. e. a world wide company) automation in the IT is KEY. Automation enables efficiency and fast development cycles. Cloud is an enabler technology. Azure has tons of technologies that could help to automate. This guide is a uncompleted and ever evolving tutorial on the automation aspect of Azure.

# With this guide you learn about 

1. Deployment basics like: scopes, ARM scripts, linked templates, secret handling, custom script extensions
1. Where to store my deployment scripts
1. Building a sofisticated deployment environments with an Azure function
1. Reference to the enterprise scale landing zone
1. Use of built in management tool like: Blueprints, Managed Apps, Custom UIs
1. A little bit of terraform


# Contact
henrik.motzkus@microsoft.com

# Status
This is work in progress and infinitely evolving 

# Demo steps
   
## Step 1: Deployment of an ARM Template on the subscription level
A deployment scope is the place where the deployment is running in Azure.

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-resource-group?tabs=azure-cli


    
This shows the different scopes of a ARM deployment


## Step 2: Deployment on an ARM Template on the resource group level

    1. This shows the different scopes of a ARM deployment
    1. This shows the safe handling of passwords while an ARM deployment
    1. This shows the handling of parameters while executing the PS command
    
## Step 3: Deployment of a nested ARM template
    1. This shows the deployments can be on different level at the same time
    1. This shows that a templated can be nested inline with the main code

## Step 4: Deployment of a script with a deployment runner like Azure function. This Azure function can deploy a ARM script

    1. Shows a Github Action to deploy Function Code to the Azure Function
    1. This shows that you can create a public REST API for template deployment
    

## Step 5: UI Hack

    1. This steps shows how to create custom UIs for user self service deployments
    1. A central unit can provide predefined deployment workflows
    
## Step 6: Enterprise Scale Landing Zone Showcase

    1. This is a comprehensive showcase of deploying an ARM template that is complex
    
## Step 7: Managed application showcase

    1. This is a demonstration of how a central unit can provide managed apps
    1. A managed app is a app where the customer is only consuming it. And not managing it.
    
## Step 8: Deploy a blueprint

    1. A blueprint can be provided by a central unit
    1. A customer can leverage the blueprint
    
## Step 9: Deployment of a Custom script Extension 

    1. Shows a Linked template 
    1. Shows Dependensies
    1. Shows the CSE
    
## Step 10: Deployment of a template spec

    1. Shows the template spec
    1. Shows Sharing in the whole enterprise
    1. Shows Modularization
    1. Shows the use of own UIs in the portal in order to create a perfect user experience
    
## Step 11: Deployment of a Managed App out of a service catalog

    1. This is a demonstration of how a central unit can provide managed apps
    1. A managed app is a app where the customer is only consuming it. And not managing it.
    1. Managed apps are protected IP of the central unit.
    
## Step 12: Deployment with Terraform

    1. This deploys a small terraform script

