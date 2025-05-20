#!/bin/bash

NAMESPACE="datadog"
RELEASE_NAME="datadog"
datadogAPIKey=$datadogAPIKey

HELM_DIR=$helmDirectory
cd $HELM_DIR/datadog
ls -al

check_namespace() {
  kubectl get namespace "${NAMESPACE}" &> /dev/null
  return $?
}

# check_helm_release() {
#     helm list -n "${NAMESPACE}" --filter "^$RELEASE_NAME$" --short &> /dev/null
#     return $?
# }

check_namespace

if [ $? -ne 0 ]; then
    echo ">>>>>> Namespace ${NAMESPACE} does not exist. Creating..."
    kubectl create namespace "${NAMESPACE}"
    if [ $? -eq 0 ]; then
        echo ">>>>>> Namespace ${NAMESPACE} created successfully."
        echo ">>>>>> Installing $RELEASE_NAME in namespace $NAMESPACE...."
        kubectl create secret generic datadog-secret -n datadog --from-literal api-key=$datadogAPIKey
        helm repo add datadog https://helm.datadoghq.com
        helm repo update
        helm install \
            edtdatadog \
            -f values.yaml \
            -n datadog \
            datadog/datadog
        echo ">>>>>> Verifiying $RELEASE_NAME installation...."
        kubectl get pods -n $NAMESPACE
    else
        echo "Failed to create namespace ${NAMESPACE}."
        exit 1
    fi
fi



