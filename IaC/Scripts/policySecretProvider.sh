#!/bin/bash
userAssignedID=$userAssignedID
kvName=$kvName
aksIdentityTenantId=$aksIdentityTenantId
environment=$environment
key_vault_url=$key_vault_url


if kubectl get namespace external-secrets > /dev/null 2>&1; then
    echo ">>>>>> Namespace external-secrets exists, decline creating namespace."
else
    echo ">>>>>> Namespace external-secrets not exist, Installing external secrets...."
    kubectl create ns external-secrets
    helm repo add external-secrets https://charts.external-secrets.io
    helm repo update
    helm upgrade --install external-secrets -n external-secrets external-secrets/external-secrets
    echo ">>>>>> Verify external-secrets installation...."
    kubectl get crds | grep secretstore
fi



echo ">>>>>> Create Secret Provider Class...."
cat <<EOF | kubectl apply -f -
    apiVersion: secrets-store.csi.x-k8s.io/v1
    kind: SecretProviderClass
    metadata:
      name: azure-kvname-workload-identity # needs to be unique per namespace
      namespace: myApp-$environment
    spec:
      provider: azure
      parameters:
        usePodIdentity: "false"
        useVMManagedIdentity: "false"          
        clientID: $userAssignedID   # Setting this to use workload identity
        keyvaultName: $kvName      # Set to the name of your key vault
        cloudName: ""                         # [OPTIONAL for Azure] if not provided, the Azure environment defaults to AzurePublicCloud
        objects:  |
          array:
            - |
              objectName: azureTEstSecretOne
              objectType: secret              # object types: secret, key, or cert
              objectVersion: ""               # [OPTIONAL] object versions, default to latest if empty
            - |
              objectName: azureTEstSecretTwo
              objectType: secret              # object types: secret, key, or cert
              objectVersion: ""               # [OPTIONAL] object versions, default to latest if empty
        tenantId: $aksIdentityTenantId       # The tenant ID of the key vault
EOF


cat <<EOF | kubectl apply -f -
  apiVersion: external-secrets.io/v1beta1
  kind: SecretStore
  metadata:
    name: myApp-secret-store
    namespace: myApp-$environment
  spec:
    provider:
      azurekv:
        authType: WorkloadIdentity
        vaultUrl: $key_vault_url
        serviceAccountRef:
          name: myApp-$environment
EOF