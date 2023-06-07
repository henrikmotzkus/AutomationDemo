# Subscription vending with ARM templates
This deploys a subscription with ARM in a existing landing zone. Purpose speed and uniformity.

## Componentents that will be deployed

1. Subscription in a existing management group
2. Role assignment (contributor) on this subscription
3. Resource group
4. Storage account in the RG
5. VNET in the RG
6. VNET Peering to existing Hub-VNET
7. Everything is tagged
8. Creates a budget on the subscription

## Open requirements

done 1. Better naming. Include a Projekt prefix into every resource
done 2. VNET settings:  UDR
done 3. Service Health alerts/ Advisor alerts for Subscription
done 4. DNS private resolver VNET link to spoke VNET
done 5. Activity Logs in ein zentrales Log Analytics
6. Resource lock on resource group (read-only)

## Instructions

1. Run setup.ps1. This creates a AAD group. This step is only available through powershell. 
2. Deploy ARM script. Change parameters accordingly to your project requirements