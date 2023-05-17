az k8s-configuration flux create \
   --name cluster-config \
   --cluster-name DESKTOP-RI2H7OG-k3s \
   --namespace cluster-config \
   --resource-group aksedge-rg \
   -u  https://github.com/henrikmotzkus/AutomationDemo.git \
   --scope cluster \
   --cluster-type connectedClusters \
   --branch main \
   --kustomization name=cluster-config prune=true path=27_ContosoPos/manifests

   https://github.com/henrikmotzkus/AutomationDemo.git