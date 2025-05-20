#!/bin/bash
echo ">>>>>> Install helm ...."
wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz
tar xvf helm-v3.9.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
sudo rm helm-v3.4.1-linux-amd64.tar.gz
sudo rm -rf linux-amd64
helm version

HELM_DIR=$helmDirectory
cd $HELM_DIR/argo-cd
ls -al

NAMESPACE="argocd"
RELEASE_NAME="argocd"

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
        helm repo add bitnami https://charts.bitnami.com/bitnami
        helm repo update
        helm install \
        argocd bitnami/argo-cd \
        -f values.yaml \
        -n argocd
        echo ">>>>>> Verifiying $RELEASE_NAME installation...."
        kubectl get pods -n $NAMESPACE
    else
        echo "Failed to create namespace ${NAMESPACE}."
        exit 1
    fi
fi

