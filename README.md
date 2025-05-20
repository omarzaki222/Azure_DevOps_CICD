Automated Microservice Deployment to AKS using Azure DevOps, Terraform, Helm, Docker, ACR, and ArgoCD
This project automates the deployment of a microservice-based application to Azure Kubernetes Service (AKS) using an Azure DevOps pipeline. The pipeline leverages multiple technologies such as Terraform, Helm, Docker, Azure Container Registry (ACR), and ArgoCD.

Architecture Diagram

Architecture
The automation process consists of the following key stages:

AKS Cluster Creation using Terraform:

The Azure DevOps pipeline uses Terraform to provision and configure an AKS cluster in Azure.
Building and Pushing Docker Images:

The microservice application is containerized, and the Docker images are built and pushed to Azure Container Registry (ACR) using Azure DevOps pipelines.
Kubernetes Deployment using Helm:

Kubernetes manifests for deploying the microservices are managed using Helm charts. A Bash script is integrated into the pipeline to execute Helm commands and deploy the services to the AKS cluster.
Continuous Deployment using ArgoCD:

ArgoCD is set up to monitor a separate Git repository, containing Kubernetes manifests or Helm charts, and deploy the changes automatically to the AKS cluster.
Pipeline Overview
1. AKS Cluster Creation with Terraform
The pipeline first provisions the necessary AKS infrastructure using Terraform. This includes:

AKS cluster
Networking (VNet, Subnets)
Role assignments and RBAC policies (if necessary)
The Terraform code is located in the infrastructure directory.

2. Build and Push Docker Images
The pipeline will:

Build Docker images for each microservice in the project.
Tag the images appropriately with version numbers or commit hashes.
Push the images to Azure Container Registry (ACR).
3. Helm Deployment via Bash Script
After the AKS cluster is up and running and the Docker images are available in ACR:

A bash script will execute helm install or helm upgrade commands to deploy the Kubernetes workloads.
Helm charts should be stored in the charts directory or referenced from an external repository.
4. Continuous Deployment with ArgoCD
ArgoCD is used to continuously monitor a separate Git repository, which contains the Helm charts or Kubernetes manifests for the application. When changes are detected in this repository, ArgoCD will automatically apply those changes to the AKS cluster.

Prerequisites
Before running this pipeline, ensure the following prerequisites are met:

Azure Subscription with appropriate permissions to create resources.
Azure DevOps Organization and Project.
Azure Container Registry (ACR) set up in your Azure subscription.
Terraform and Helm installed locally (for manual runs).
ArgoCD installed and configured in the AKS cluster.
Getting Started
1. Set up Azure DevOps Pipelines
Create a pipeline for infrastructure provisioning (Terraform) and application deployment (Docker, Helm).
Ensure the pipeline is connected to your Git repository containing the source code, Dockerfiles, and Helm charts.
2. Configure ACR and AKS Access
Set up the appropriate Azure DevOps service connections for Azure Resource Manager (ARM) and Azure Container Registry (ACR).
Ensure the AKS cluster has proper access to pull images from ACR.
3. Configure ArgoCD
Install ArgoCD in your AKS cluster.
Configure ArgoCD to monitor the repository containing the Helm charts or Kubernetes manifests.
4. Trigger the Pipeline
Push your code to the Git repository to trigger the Azure DevOps pipeline.
