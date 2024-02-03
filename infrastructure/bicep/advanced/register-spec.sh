#!/bin/bash

# Current configuration - extract the subscription id and tenant id
az account show --query "{subscription:name, subscription_ID:id, tenant_ID:tenantId}" --output table

# bash prompt user for input
read -p "Is this the correct subscription? (y/N): " subok
# if y (case insensitive) then continue else tell user to log in and set account
if [ "$subok" != "y" ]; then
    echo "Please run \"az login\" followed by \"az account set -s <subscription>\""
    exit 1
fi

# prompt for resource group name, suggest default value "utils"
read -p "Enter the resource group name for bicep template specs (leave blank for default 'templateSpecs'): " RG  
RG=${RG:-templateSpecs}

# prompt for resource group name, suggest default value "utils"
read -p "Short spec name (default Geosearch): " specName 
specName=${specName:-Geosearch}
read -p "Spec version (default 1.0): " specVersion
specVersion=${specVersion:-1.0} 

az group create --name $RG -l uksouth

az ts create \
  --name $specName \
  --version $specVersion \
  --resource-group $RG \
  --location uksouth \
  --template-file "../main.bicep" \
  --description "Geosearch POC resources" \
  --tags "accelerator=geosearch" 

