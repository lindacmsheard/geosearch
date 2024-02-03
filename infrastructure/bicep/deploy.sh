#!/bin/bash

# Current configuration
az account show

# bash prompt user for input
read -p "Is this the correct subscription for the deployment (y/N): " subok
# if y (case insensitive) then continue else tell user to log in and set account
if [ "$subok" != "y" ]; then
    echo "Please run `az login` followed by `az account set -s <subscription>`"
    exit 1
fi

# prompt for resource group name
read -p "Enter the new resource group name for the deployment: " RG


az group create --name $RG --location uksouth

az deployment group create \
    --resource-group $RG \
    --template-file main.bicep \
    --parameters project=$RG

