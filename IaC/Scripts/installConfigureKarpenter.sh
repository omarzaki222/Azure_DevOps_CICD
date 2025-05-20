#!/bin/bash


helmDirectory=$helmDirectory
userAssignedID=$userAssignedID
tenantId=$tenantId
userAssignedName=$userAssignedName
terraformResourceGroup=$terraformResourceGroup
namespace=$namespace
servicePrincipalId=$servicePrincipalId
servicePrincipalKey=$servicePrincipalKey
subscriptionId=$subscriptionId
aks_name=$aks_name
terraformResourceGroup=$terraformResourceGroup
region=$region
userAssignedPrincipalID=$userAssignedPrincipalID
DefaultWorkingDirectory=$DefaultWorkingDirectory
aks_oicd_url=$aks_oicd_url


cd $helmDirectory/karpenter
ls -al

check_namespace() {
  kubectl get namespace "${namespace}" &> /dev/null
  return $?
}

echo ">>>>> Create karpenter namespace....."
kubectl create ns karpenter
echo ">>>>> Create karpenter serviceAccount....."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
    name: karpenter
    namespace: karpenter
    annotations:
        azure.workload.identity/client-id: $userAssignedID
        azure.workload.identity/tenant-id: $tenantId
    labels:
        azure.workload.identity/use: "true"
EOF

echo ">>>>> Annotate ServiceAccount....."
kubectl annotate serviceaccount karpenter -n karpenter meta.helm.sh/release-name=karpenter
kubectl annotate serviceaccount karpenter -n karpenter meta.helm.sh/release-namespace=karpenter
kubectl label serviceaccount karpenter -n karpenter app.kubernetes.io/managed-by=Helm

echo ">>>>> Create karpenter Federated Credentials....."
az identity federated-credential create --name karpenterFedCredId \
    --identity-name $userAssignedName \
    --resource-group $terraformResourceGroup \
    --issuer $aks_oicd_url \
    --subject system:serviceaccount:karpenter:karpenter

echo ">>>>> Setting Env Vars....."
echo ">>>>>> Logging into AZ SP ...."
az login --service-principal --username $servicePrincipalId --password $servicePrincipalKey --tenant $tenantId

echo ">>>>>> Setting subscriptionID ...."
az account set --subscription $subscriptionId

export CLUSTER_NAME=$aks_name
echo "Cluster Name is: $CLUSTER_NAME"
export AZURE_RESOURCE_GROUP=$terraformResourceGroup
echo "Resource Group Name is:$AZURE_RESOURCE_GROUP"
export AKS_JSON=$(az aks show --name "$CLUSTER_NAME" --resource-group "$AZURE_RESOURCE_GROUP")
echo "AKS Json: $AKS_JSON"
export AZURE_LOCATION=$(jq -r ".location" <<< "$AKS_JSON")
echo "Location is: $AZURE_LOCATION"
export AZURE_RESOURCE_GROUP_MC=$(jq -r ".nodeResourceGroup" <<< "$AKS_JSON")
echo "AKS MC Resource Group: $AZURE_RESOURCE_GROUP_MC"
export CLUSTER_ENDPOINT=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
echo "Cluster Endpoint is: $CLUSTER_ENDPOINT"
export TOKEN_SECRET_NAME=$(kubectl get -n kube-system secrets --field-selector=type=bootstrap.kubernetes.io/token -o jsonpath='{.items[0].metadata.name}')
echo "Token Secret Name is: $TOKEN_SECRET_NAME"
export TOKEN_ID=$(kubectl get -n kube-system secret "$TOKEN_SECRET_NAME" -o jsonpath='{.data.token-id}' | base64 -d)
echo "Token ID is: $TOKEN_ID"
export TOKEN_SECRET=$(kubectl get -n kube-system secret "$TOKEN_SECRET_NAME" -o jsonpath='{.data.token-secret}' | base64 -d)
echo "Token Secret is: $TOKEN_SECRET"
export BOOTSTRAP_TOKEN=$TOKEN_ID.$TOKEN_SECRET
echo "Bootstrap Token is: $BOOTSTRAP_TOKEN"
export VNET_JSON=$(az network vnet list --resource-group "$AZURE_RESOURCE_GROUP" | jq -r ".[0]")
echo "Vnet Json is: $VNET_JSON"
export VNET_SUBNET_ID=$(jq -r ".subnets[0].id" <<< "$VNET_JSON")
echo "Vnet Subnet id is: $VNET_SUBNET_ID"
export NODE_IDENTITIES=$(jq -r ".identityProfile.kubeletidentity.resourceId" <<< "$AKS_JSON")
echo "Vnet Node Identities: $NODE_IDENTITIES"
export CLIENT_ID=$userAssignedID
echo "Client ID is: $CLIENT_ID"
export KEY_NAME="id_rsa"
export KEY_DIR="$HOME/.ssh"
export KEY_PATH="$KEY_DIR/$KEY_NAME"
export COMMENT="your_email@example.com"

echo ">>>>> Generate SSH Key....."
mkdir -p "$KEY_DIR"
# Generate the SSH key
ssh-keygen -t rsa -b 4096 -C "$COMMENT" -f "$KEY_PATH" -N ""
export SSH_PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub) azureuser"
echo "SSH Key is: $SSH_PUBLIC_KEY"

export SUBSCRIPTION_ID=$subscriptionId
echo "Subscription ID is: $SUBSCRIPTION_ID"
export LOCATION=${{ parameters.region }}
echo "Location is is: $LOCATION"



echo ">>>>> Change Karpenter Values.yaml file with proper values....."
echo ">>>>> Values before the adjustment....."
cat $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.controller.env[2].value = env(CLUSTER_NAME)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.controller.env[3].value = env(CLUSTER_ENDPOINT)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.controller.env[4].value = env(BOOTSTRAP_TOKEN)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.controller.env[5].value = env(SSH_PUBLIC_KEY)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.controller.env[8].value = env(VNET_SUBNET_ID)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.controller.env[9].value = env(NODE_IDENTITIES)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.controller.env[11].value = env(LOCATION)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.serviceAccount.annotations."azure.workload.identity/client-id" = env(CLIENT_ID)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.controller.env[15].value = env(AZURE_RESOURCE_GROUP_MC)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml
yq eval -i '.controller.env[10].value = env(SUBSCRIPTION_ID)' $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml

echo ">>>>> Create role assignments for Karpenter on AKS MC RG....."
for role in "Virtual Machine Contributor" "Network Contributor" "Managed Identity Operator"; do
    az role assignment create --scope $AZURE_RESOURCE_GROUP_MC --subscription $subscriptionId --assignee-object-id $userAssignedPrincipalID --assignee-principal-type "User" --role "$role --tenant $tenantId"
done

echo ">>>>> Values After the adjustment....."
cat $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml

echo ">>>>> Install Karpenter Helm Chart....."
helm upgrade --install karpenter oci://mcr.microsoft.com/aks/karpenter/karpenter \
    -n karpenter \
    --values $DefaultWorkingDirectory/$helmDirectory/karpenter/values.yaml \
    --set controller.resources.requests.cpu=1  \
    --set controller.resources.requests.memory=1Gi \
    --set controller.resources.limits.cpu=1 \
    --set controller.resources.limits.memory=1Gi \
    --wait \
    --debug


echo ">>>>> Create karpenter NodePool....."
cat <<EOF | kubectl apply -f -
---
apiVersion: karpenter.sh/v1beta1
kind: NodePool
    metadata:
    name: general-purpose
    annotations:
        kubernetes.io/description: "General purpose NodePool for generic workloads"
spec:
    template:
    spec:
        requirements:
            - key: kubernetes.io/arch
                operator: In
                values: ["amd64"]
            - key: kubernetes.io/os
                operator: In
                values: ["linux"]
            - key: karpenter.sh/capacity-type
                operator: In
                values: ["on-demand"]
            - key: karpenter.azure.com/sku-family
                operator: In
                values: [D]
        nodeClassRef:
            name: default
        limits:
            cpu: 100
        disruption:
            consolidationPolicy: WhenUnderutilized
            expireAfter: Never
---
apiVersion: karpenter.azure.com/v1alpha2
kind: AKSNodeClass
metadata:
    name: default
    annotations:
        kubernetes.io/description: "General purpose AKSNodeClass for running Ubuntu2204 nodes"
spec:
    imageFamily: Ubuntu2204
EOF

echo ">>>>> Deploy Metrics Server....."
kubectl apply -f $DefaultWorkingDirectory/Manifests/metrics-server.yaml
