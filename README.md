# Azure Automation Demo

## 1. tl;dr

This is a technical demonstration to try out many aspects of automating Azure management tasks. The deploy.ps1 is the command center to roll out all demo steps. This is totally tech focussed. ;-)

When you in front of your first  Azure project please have a look at the official Microsoft "Cloud adoption framework" first.



## 2. Problem statement

In huge cloud environments (i. e. a world wide distributed company IT) automation in IT is KEY. Automation enables efficiency and fast development cycles. Cloud is an enabler technology. Azure has tons of technologies that could help you to automate operation. This guide is a uncompleted but ever evolving tech tutorial. This is a result of my consulting role at my customer.

## 3. With this guide you learn about

The world of automation is dominated by declarative languages. Declarative means that you describe your status and move your infrastructure toward this status. ARM, Terraform HCL, YAML,  you name it. Declarative languages are fundamental different in comparison to imperative languages. But you wouldn't miss also imperative languages like Powershell and Bash-Scripts. Be flexible and choose alway according to your needs. 

This guide helps you to leverage modern IaC in regards to Azure.

You can work with it like a tutorial. Start with the basic steps. And work through all the way down the steps.

This guide is also leveraging technologies from Non-Microsoft parties. This guide isn't meant as a pro-microsoft brainwashing.

### Technologies

However this is a tutorial that can be worked through from top to bottom I want to list all technologies used.

1. ARM Basics
    1. Scopes
    1. linked templates
    1. secret handling
    1. custom script extensions
    1. Referencing managed identities
1. Azure functions
    1. For Deployments 
    1. As TF provider
1. Enterprise scale landing zone
    1. ARM 
    1. Terraform
1. Built in management tools
    1. Blueprints 
    1. Managed Apps 
    1. Custom UIs
1. Terraform
    1. Gaia
    1. Own TF provider
    1. Modules
    1. Cloud adoption framework
1. Custom User interfaces for your ARM deployments
1. Automanage fpr VM
1. Desired State Configuration
1. Custom script extension
1. The Azure deploy button

## 4. How to use

    1. Clone the repository to your local workstation.
    2. Open it with Visual Studio Code. 
    3. "deploy.ps1" is the command center. Open deploy.ps1, every step will be rolled out with this script.
    4. Change your subscription ID and location in the deploy.ps1
    5. The "Folder prefix" in the heading marks accordingly the folder where the scripts exists

## 5. Contact

henrik.motzkus@microsoft.com

## 6. Status

This is work in progress and infinitely evolving.

Disclaimer: This demo doesn't explain the concepts itself. It combines the various features and demonstrates the value. For education please visit the official documentation of Microsoft.

Disclaimer 2: This is not an explanation of the Azure Service "Azure Automation". The service "Azure Automation" is a tool. This demo here is a comprehensive overview about all aspects of automating the Azure cloud.

## 7 Demo steps

### 7.1 (Folder prefix 1) Deployment of an ARM Template on different scopes

A deployment scope is the place where the deployment is running and placing the resources your're about to deploy in Azure.

[Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-resource-group?tabs=azure-cli)

    Instructions:    
    1. Run the commands in the powershell

### 7.2 (Folder prefix 2) Deployment an ARM Template on the resource group level

This deployment deploys a VM on the resource group scope. The VM password is securely stored in a kevvault and not hardcoded in the script. First you need to deploy that keyvault and its secret. And it shows a different method of parameter handling.

[Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter?tabs=azure-cli)

    Instructions:
    1. Run the commands in the powershell

### 7.3 (Folder prefix 3) Deployment of a nested ARM template

This deployment shows a combined deployment that is beeing rolled out on different scopes at the same time. And it shows that this can be achieved with a nested ARM script. Nesting script is a way to modularize your scripts.

[Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates?tabs=azure-powershell)

    Instructions: 
    1. Run the commands in the powershell

### 7.4 (Folder prefix 4) Deployment of a script with a deployment runner like Azure function

This Azure function can deploy a ARM script

This step shows the deployment of a Azure function. The functionality of the function to run deployments in Azure. The function code is rolled out with Github actions. In 4_FunctionCode you'll find the code of the function.

Purpose of is to demonstrate that you could leverage Azure function for nearly every automation purpose. Call a REST API while deploying? Inform security systems after deployment? Send mails? incorporate billing system? Everything is possible with Azure functions. 

    Instructions: 
    1. Run the commands in the powershell
    2. Assigning a 'System assigned' identity to the Azure function
    3. Assign 'contributor rights' to that identity
    4. Get the URL of the function
    5. Call the function via REST Call 

### 7.5 (Folder prefix 5) Own UI definitions

Arm templates need to ingest parameters. With a UI definition you're able to create beautiful UIs on Azure to customize the customer experience. Especially in big companies a lot of information needs to be incorporated at the time of deployment.

As a central unit you can provide a self service UI for your customers.

    Instructions:
    1. Call the WebUrl in the deploy.ps1

### 7.6 (Folder prefix 6) Azure DevTestLabs

A DevTestLab in Azure is a curated environment where you as a central uni can offer your customers cloud environments in a self service fashion. Fully controlled and with budgets activated.

[Docs](https://docs.microsoft.com/en-us/azure/devtest-labs/devtest-lab-overview)

    Instructions:    
    TODO

### 7.7 (Folder prefix 7) Managed applications

A managed app is a offering you can make on the Azure marketplace. You as a company can offer your software solution a managed service provider. Potential customer can deploy your solution in their subscription by a click.

[Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/overview)

    Instructions: 
    TODO

### 7.8 (Folder prefix 8) Deploy a blueprint

With blueprints a central unit can provide ARM templates, assigned policies, assign roles, and assigned management groups as a UNIT. A internal "customer" can use the blueprint in order to roll out that blueprint. Blueprints are curated deployment.

[Docs](https://docs.microsoft.com/en-us/azure/governance/blueprints/)

    Instructions: 
    1. Run the commands in the powershell. 
    1. Go to the portal an assign the blueprint manually

### 7.9 (Folder prefix 9) Deployment of a Custom script Extension

This deploys a VM from the script out of step 2. And a custom script extension into the VM. A CSE is a deployment script that can be used to deploy additional scripts after the deployment of the VM itself.

[Docs](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows)

    Instructions: 
    1. Run the commands in the powershell

### 7.10 (Folder prefix 10) Deployment of a template spec

This uploads a template Spec to Azure and deploys it. A template spec can be used to modularize the ARM template and share it in the whole company. This demo uses the script from step 2. And it uses a nested template out of step 10. You can provide a own UI definition.

[Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell)

    Instructions:
    1. Run the commands in the powershell.
    2. GO to the portal an use the template spec there

### 7.11 (Folder prefix 11) Deployment of a Managed App out of a service catalog

This uploads a managed app to the service catalog of a Azure environment.

[Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/deploy-service-catalog-quickstart)

    Instructions: 
    1. Run the commands in the powershell
    2. Go to the portal and deploy a app out of the service catalog



### 7.12 (Folder prefix 12) Deployment in Azure with Terraform

Terraform is the defacto industry standard when it comes to cloud management with IaC. In this chapter I want to demo the various possibilities with Terraform and Azure. At the moment we have 4 demo steps.

**Part 1 (Folder: 12_Terraform):** This TF deploys a resource group. This is the simple case. But not like the real world. ;-)

**Part 2 (Folder: 12_Terraform_ADJoin):** This TF deploys a VNET, a domain controller and a domain member. It spans up the forest. And it joins the VM to the domain. Outcome: It automates the infrastructure deployment and the VM configuration.

**Part 3 (Folder: 12_Terraform_Own_provider):** This TF uses a custom TF provider. The custom TF provider is providing a VM name. It is a data resource. Imagine you act like a internal CMDB-manager and you like to automatically issue VM-names for the purpose of deployment. The backend REST API is implemented with a Azure function that is deployed in folder 4_FunctionCode. With this you could offer company internal cloud fashioned services. Easily write your own Terraform provider for all purposes.

[More: I copied a lot out of this blog post.](https://boxboat.com/2020/02/04/writing-a-custom-terraform-provider/)

**Part 4 (Folder: 12_Terraform_Gaia):** Gaia is a UI on top of TF. With this step you could span up a AKS cluster in Azure and install Gaia on top of that. You could find the Gaia project here <https://github.com/gaia-app>

[API Details](https://github.com/henrikmotzkus/AutomationDemo/blob/main/12_Terraform_Own_provider/README.md)

[Docs](https://docs.microsoft.com/en-us/azure/developer/terraform/)

    Instructions:
    1. Install Azure CLI on your workstation
    2. Install terraform on your workstation
    3. Run the commands in the powershell

**Part5 (Folder: 12_TerraformCAF):** The Enterprise scale landingzone (ESLZ) is a reference implementation of design principles regarding the right use of Azure in big organizations. See step 16 in order to learn about the ESLZ principles.


[Docs TF on Azure](https://docs.microsoft.com/en-us/azure/developer/terraform/overview) 




[Docs TF modul enterprise scale landing zone](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest)




### 7.13 (Folder prefix 13) Code deployment with Github Actions

Github action is a pipeline enging that could be leveraged for code push to your hosting environment like Azure functions.

In step 4 you deployed a Azure function. The code deployment onto the Azure function is achieved with Github actions. In the folder **\.github\workflows** you'll find a workflow definition to deploy code from Github to the function. The file is called **main_powershelldeployfunction.yaml**, In order to get it running follow the instructions.

[Docs](https://docs.microsoft.com/en-us/azure/developer/github/github-actions/)

    Instructions: 
    1. Download the publish profile from the function. Created in step 4
    2. Create a secret in the project on github with the name "AZUREAPPSERVICE_PUBLISHPROFILE_5DC798FB4A2C4E18A92AC6A29A7C3462" and insert the publish profile text into it.
    3. Push the workflow definiton to your github account. In our case you could push this repo to your own repo on github. 

### 7.14 (Folder prefix 14) Cod deployment with Azure DevOps

TODO 

You can deploy ARM script within the boundary of a development project with the help of Azure DevOps.

[Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/add-template-to-azure-pipelines)

    Instructions:
    1. Create a Azure DevOps project 
    2. Upload Code
    3. Create a pipeline

### 7.15 (Folder prefix 15) The Azure TeamCloud

TODO 

The TeamCloud is a community project spinned up by Markus Heiliger a colleague from me. Purpose is to provide development teams a self-service for provisioning compliant cloud development environments.

[Github project](https://github.com/microsoft/TeamCloud)

    Instructions:
    1. Install the Azure CLI extension for TeamCloud
    1. Run the commands in the powershell
    
### 7.16 (Folder prefix 16) Enterprise Scale Landing Zone (ESLZ)

Every company that enters Azure needs a landingzone where workload can be hosted. This is the most important preparation on front of every first Azure project. The landingzone defines Policies, Connectivity options, Structure, Billing, and many more aspects of the Azure cloud.

Benefits:
1. With this methodology you as a cloud admin can provide self service capabilities to other parts of your organization.
1. Use the code base as a starting point for your own templates.


[Official Docs](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/architecture)

With the click on this button you will be redirected to the Azure management portal and submit the deployment template. The ARM template is located [here](https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/wingtip/README.md). This is a starter configuration fitted to small environments. 


[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FEnterprise-Scale%2Fmain%2FeslzArm%2FeslzArm.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FEnterprise-Scale%2Fmain%2FeslzArm%2Feslz-portal.json)

[Here](https://github.com/Azure/Enterprise-Scale) you find the whole code base.

### 7.17 (Folder prefix 17) Azure Automanage for Virtual machines

TODO
    
    Instructions
    

### 7.18 (Folder prefix 18) Event handling with Azure Automation and Event grid