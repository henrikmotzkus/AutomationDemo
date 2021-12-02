# 1. Azure Automation Demo tl;dr
This is a tutorial to try out many aspects of automating Azure management tasks. The deploy.ps1 is the command center to roll out all demo steps.

# 2. Problem statement
In huge environments (i. e. a world wide company) automation in the IT is KEY. Automation enables efficiency and fast development cycles. Cloud is an enabler technology. Azure has tons of technologies that could help to automate. This guide is a uncompleted and ever evolving tutorial on the automation aspect of Azure.

# 3. With this guide you learn about 
THe world of automation is dominated by declarative languages. Declarative means that you describe your status and move your infrastructure toward this status. ARM, Terraform, YAML, you name it. Declarative languages are fundamental different in comparison to imperative languages. 

This guide helps you to leverage modern IaC in regards to Azure. 

You can work with it like a tutorial. Start with the basic steps. 

## Topics 

1. Deployment basics like: scopes, ARM scripts, linked templates, secret handling, custom script extensions
2. Where to store my deployment scripts
3. Building a sofisticated deployment environments with an Azure function
4. Reference to the enterprise scale landing zone
5. Use of built in management tool like: Blueprints, Managed Apps, Custom UIs
6. A little bit of terraform
7. A lot of other techniques for automating Azure

# 4. How to use

    1. Clone the repository to your local workstation. 
    2. Open it with Visual Studio Code. 
    4. "deploy.ps1" is the command center. Open deploy.ps1, every step will be rolled out with this script.
    5. Then change your subscription ID and location in the deploy.ps1

# 5. Contact
henrik.motzkus@microsoft.com

# 6. Status
This is work in progress and infinitely evolving.

Disclaimer: This demo doesn't explain the concepts itself. It combines the various features and demonstrates the value. For education please visit the official documentation.

# 7. Demo steps
    
## 7.1 Basics

These are basic technologies to get a basic understanding of how the most underlying technologies works. 

### 7.1.1 (Step 1) Deployment of an ARM Template on different scopes 

A deployment scope is the place where the deployment is running and placing the resources your're about to deploy in Azure.

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-resource-group?tabs=azure-cli

    Instructions:    
    1. Run the commands in the powershell

### 7.1.2 (Step 2) Deployment on an ARM Template on the resource group level

This deployment deploys a VM on the resource group scope. The VM password is securely stored in a kevvault and not hardcoded in the script. First you need to deploy that keyvault and its secret. And it shows a different method of parameter handling. 

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter?tabs=azure-cli

    Instructions:
    1. Run the commands in the powershell
    
### 7.1.3 (Step 3) Deployment of a nested ARM template

This deployment shows a combined deployment that is beeing rolled out on different scopes at the same time. And it shows that this can be achieved with a nested ARM script. Nesting script is a way to modularize your scripts.

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates?tabs=azure-powershell

    Instructions: 
    1. Run the commands in the powershell
    
## 7.2 Advanced features of Azure
These features use the basics and extends the basic layers with more functionality.

### 7.2.1 (Step 4) Deployment of a script with a deployment runner like Azure function. This Azure function can deploy a ARM script
This step shows the deployment of a Azure function. The functionality of the function to run deployments in Azure. The function code is rolled out with Github actions. In 4_FunctionCode you'll find the code of the function.

Purpose of is to demonstrate that you could leverage Azure function for nearly every automation purpose. Call a REST API while deploying? Inform security systems after deployment? Send mails? incorporate billing system? Everything is possible with Azure functions. 

    Instructions: 
    1. Run the commands in the powershell
    2. Assing a 'System assigned' identity to the Azure function
    3. Assign 'contributor rights' to that identity
    4. Get the URL of the function
    5. Call the function via REST Call 
    

### 7.2.2 (Step 5) Own UI definitions
Arm templates need to ingest parameters. With a UI defintion you're able to create beautiful UIs on Azure to customize the customer experience. Especially in big companies a lot of information needs to be incorporated at the time of deployment. 

As a central unit you can provide a self service UI for your customers.

    Instructions:
    1. Call the WebUrl in the deploy.ps1

### 7.2.3 (Step 6) Azure DevTestLabs
A DevTestLab in Azure is a currated environment where you as a central uni can offer your customers cloud environments in a self service fashion. Fully controlled and with budgets activated.

More: https://docs.microsoft.com/en-us/azure/devtest-labs/devtest-lab-overview

    Instructions:    
    TODO
   
### 7.2.3 (Step 7) Managed applications
A managed app is a offering you can make on the Azure marketplace. You as a company can offer your software solution a managed service provider. Potential customer can deploy your solution in their subscription by a click. 

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/overview

    Instructions: 
    TODO
    
### 7.2.4 (Step 8) Deploy a blueprint
With blueprints a central unit can provide ARM templates, assigned policies, assign roles, and assigned management groups as a UNIT. A internal "customer" can use the blueprint in order to roll out that blueprint. Blueprints are currated deployment. 

More: https://docs.microsoft.com/en-us/azure/governance/blueprints/

    Instructions: 
    1. Run the commands in the powershell. 
    1. Go to the portal an assign the blueprint manually
    
### 7.2.5 (Step 9) Deployment of a Custom script Extension
This deploys a VM from the script out of step 2. And a custom scription extension into the VM. A CSE is a deployment script that can be used to deploy additional scripts after the deployment of the VM itself. 

More: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows

    Instructions: 
    1. Run the commands in the powershell


### 7.2.6 (Step 10) Deployment of a template spec
This uploads a template Spec to Azure and deploys it. A template spec can be used to modularize the ARM template and share it in the whole company. This demo uses the script from step 2. And it uses a nested template out of step 10. You can provide a own UI definition.

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
Now we're entering the world of additional tools and frameworks that deliver more value and help to automate Azure management tasks as much as possible.

### 7.3.1 (step 16) Enterprise Scale Landing Zone Showcase
This is a comprehensive showcase of deploying an ARM template that is complex. This shows a full working template deployment for big environments.

More: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/architecture

    Instructions:
    Visit the github project 

### 7.3.2 (Step 12) Deployment in Azure with Terraform
Terraform is the defacto industry standard when it comes to cloud management with IaC. This step consist of two poert. First script only deploys a simple resource group. THe second part deploys a VNET, domain controller VM and a domain member VM. On top of that part 2 is modularized. This is one of the strength of TF. Then part 2 shows what you could automize in the VM itself. It run several scripts insoder the VM after deployment in Azure.

Part 1 (simple) : This TF deploys a resourceg roup
Part 2 (complex): This TF deploys a VNET, domain controller and a domain member


More: https://docs.microsoft.com/en-us/azure/developer/terraform/

    Instructions:
    1. Install Azure CLI on your workstation
    2. Install terraform on your workstation 
    3. Run the commands in the powershell

### 7.3.3 (Step 13) Deployment with Github Actions
In step 4 you deployed a Azure function. The code deployment onto the Azure function is achieved with Github actions. In \.github\workflows you'll find a workflow to deploy code from Github to the function. 

More: https://docs.microsoft.com/en-us/azure/developer/github/github-actions

    Instructions: 
    1. Download the publish profile from the function. Created in step 4
    2. Create a secret an the project with the name "AZUREAPPSERVICE_PUBLISHPROFILE_5DC798FB4A2C4E18A92AC6A29A7C3462" and insert the publish profile text into it.
    3. Push the workflow definiton (.github/) to your github account
    

### 7.3.4 (Step 14) Deployment with Azure DevOps
You can deploy ARM script within the boundary of a development project with the help of Azure DevOps.

More: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/add-template-to-azure-pipelines

    Instructions:
    1. Create a Azure DevOps project 
    2. Upload Code
    3. Create a pipeline

### 7.3.5 (Step 15) The Azure TeamCloud

More: https://github.com/microsoft/TeamCloud


    Instructions:
    1. Visit the github project!

### 7.3.6 (step 17) Azure Automanage for Virtual machines
    
    Instructions
    TODO
