#!/bin/bash
userAssignedID=$userAssignedID
userAssignedName=$userAssignedName
tenantId=$tenantId
environment=$environment
aks_oicd_url=$aks_oicd_url
terraformResourceGroup=$terraformResourceGroup

if kubectl get namespace myApp-prod > /dev/null 2>&1; then
    echo ">>>>>> Namespace myApp-prod exists, decline creating namespace."
else
    kubectl create ns myApp-$environment
fi


echo ">>>>> Create myApp-dev SA for secret store to access AKV....."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
    name: myApp-$environment
    namespace: myApp-$environment
    annotations:
        azure.workload.identity/client-id: $userAssignedID
        azure.workload.identity/tenant-id: $tenantId
    labels:
        azure.workload.identity/use: "true"
EOF

echo ">>>>> Create the FIC betn the MI, the SAI, and the myApp App....."
az identity federated-credential create --name myApp$environment --identity-name $userAssignedName \
    --resource-group $terraformResourceGroup \
    --issuer $aks_oicd_url \
    --subject system:serviceaccount:myApp-$environment:myApp-$environment