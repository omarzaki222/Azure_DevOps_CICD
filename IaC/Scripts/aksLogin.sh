#!/bin/bash
echo ">>>>>> Logging into AZ SP ...."
az login --service-principal --username $servicePrincipalId --password $servicePrincipalKey --tenant $tenantId

echo ">>>>>> Setting subscriptionID ...."
az account set --subscription $subscriptionId

echo ">>>>>> Getting Cluster Credentials ...."
az aks get-credentials --resource-group $terraformResourceGroup --name $clusterName

echo ">>>>>> Running kubelogin ...."
kubelogin convert-kubeconfig -l azurecli

echo ">>>>>> Getting Cluster Nodes for Testing ...."
kubectl get nodes -o wide

