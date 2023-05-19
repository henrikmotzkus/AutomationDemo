# Deploy ContosoPOS 

> tl;dr This deploys the ContosoPOS demo solution on a AKS Edge Essential on a Windows 10 IoT Enterprise device

This is a demo installing a POS demo software (cashier system) that is build on container technology on a windows 10 iot device. The POS itself is build with python and a mysql database onto container. Below in the docs you'll find the original project. These container will be installed in an AKS that is running on a one node windows 10 IoT OS. The Azure Arc integration will deploy the solution automatically onto this node. 

Why? This is a showcase how run and maintain modern software architecures on at the forefront of the retail business. At the shopflor. 

## Prereqs

- Windows 10 Iot capable device
- Azure Subscription
- Windows 10 IoT Enterprise image (.iso)
- USB Stick
- Azure CLI

## Steps

1. Deploy Windows 10 IoT Enterprise https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/iot-ent-overview?view=windows-10
2. Install AKS Edgea Essentials https://learn.microsoft.com/en-us/azure/aks/hybrid/aks-edge-quickstart
3. Configure GitOPS https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-gitops-flux2-ci-cd#connect-the-gitops-repository-1


### 1. 

### 2. 


### 3. Configure GitOPS

Use the Azure CLI command in `configure.sh` to register your cluster to GitOPS. Then the flux agent will install the app onto your AKS cluster.


## Docs

This is the Microsoft demo solution that shows a very basic POS solution
https://raw.githubusercontent.com/microsoft/azure-arc-jumpstart-apps/main/contoso-supermarket/prod/yaml/contosopos.yaml


https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/hardware/prototype