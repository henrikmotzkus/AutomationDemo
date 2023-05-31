# Subscription vending with ARM templates

## Componentents that will be deployed

1. Subscription in a existing management group
2. Role assignment (contributor) on this subscription
3. Resource group
4. Storage account in the RG
5. VNET in the RG
6. VNET Peering to existing Hub-VNET
7. Everything is tagged
8. Creates a budget on the subscription


## Open points

1. Better naming. Include a Projekt prefix into every resource
2. VNET settings: DNS, UDR
3. Service Health alerts/ Advisor alerts for Subscription
4. DNS private resolver VNET link to spoke VNET

