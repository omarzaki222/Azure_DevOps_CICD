#!/bin/bash

# Variables
servicePrincipalId=$servicePrincipalId
servicePrincipalKey=$servicePrincipalKey
subscriptionId=$subscriptionId
tenantId=$tenantId
resourceGroupName=$resourceGroupName
location=$location
storageAccountName=$storageAccountName
terraformK8sContainerName=$terraformK8sContainerName

echo ">>>>>> Logging into AZ SP ...."
az login --service-principal --username $servicePrincipalId --password $servicePrincipalKey --tenant $tenantId

echo ">>>>>> Setting subscriptionID ...."
az account set --subscription $subscriptionId


# Function to check if a resource group exists
check_resource_group() {
  az group show --name $resourceGroupName &> /dev/null
  return $?
}

# Function to create a resource group
create_resource_group() {
  az group create --name $resourceGroupName --location $location
  return $?
}

# Function to create a storage account
create_storage_account() {
  az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS
  STORAGE_ACCOUNT_KEY=$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query '[0].value' --output tsv)
  az storage container create --name $terraformK8sContainerName --account-name $storageAccountName --account-key $STORAGE_ACCOUNT_KEY
  return $?
}

# Check if the resource group exists
check_resource_group

if [ $? -ne 0 ]; then
  echo "Resource group $resourceGroupName does not exist. Creating..."
  create_resource_group
  if [ $? -eq 0 ]; then
    echo "Resource group $resourceGroupName created successfully."
    # Check if storage account exists
    echo "Creating StorageAccount: $storageAccountName and Container: $terraformK8sContainerName inside $resourceGroupName....."
    create_storage_account
    if [ $? -eq 0 ]; then
      echo "Storage account $storageAccountName created successfully."
    else
      echo "Failed to create storage account $storageAccountName."
      exit 1
    fi
  else
    echo "Failed to create resource group $resourceGroupName."
    exit 1
  fi
else
  echo "Resource group $resourceGroupName already exists."
fi




