# This is a demo for medium scale P2S VPN VWAN installation

## Problem statement

Use Azure vwan for P2S client connectivity to a central connectivity hub. Client is managed with Intune and devices should be registered to the intune tenant when company user is using it. Company has a legacy AD Domain. VPN authentication via certificates from a certificate authorization.    

## Components in the Architecture

1. Intune -> Rolling out configuration profiles to the client
2. Azure VPN Client -> for Open SSL connection to the central hub
3. Azure VWAN hub -> As central hub
4. Some Workload VNETs in Azure -> For datacenter workload
5. A Forest and a Domain ->like in every company
6. A Certificate Authority -> For certificate based authentication

## Setup steps

1. Build a CA
2. Install Intune Certificate COnnector
3. Configure Intune User Groups
4. Setup Intune Configuration Profiles
