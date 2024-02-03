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

# prompt for spec resource group name and list specs
read -p "Enter the resource group name containing your Bicep template specs (leave blank for default 'templateSpecs'): " templateSpecRG
templateSpecRG=${templateSpecRG:-templateSpecs}
az ts list -g $templateSpecRG --output table
echo -e "\n"

# prompt for spec name
read -p "Name of templateSpec to deploy (leave blank for default: Geosearch)" specName
specName=${specName:-Geosearch}

# get list of versions for specname and prompt user for version
echo -e "Versions for $specName: \n------------------------"
az ts show  -n $specName -g $templateSpecRG --query versions -o tsv
echo -e "\n"

read -p "Use version (leave blank for default: 1.0): " specVersion
specVersion=${specVersion:-1.0}

# get the id for specName specVersion from az ts show:
id=$(az ts show --name $specName --version $specVersion --resource-group $templateSpecRG --query id --output tsv)

# prompt for new resource group name for deployment
read -p "Enter a new resource group name to deploy to: " RG

az group create --name $RG --location uksouth --tags "managedBy=bicep"

# subscription-level deployment stack. For group level, use az stack group create with --resource-group instead of --deployment-resource-group
az stack sub create \
    --name $RG-stack \
    --deployment-resource-group $RG \
    --template-spec $id \
    --parameters project=$RG \
    --tags "managedBy=bicep" \
    --deny-settings-mode none
    #--deny-settings-mode denyWriteAndDelete \
    #--deny-settings-excluded-principals $(az ad signed-in-user show --query id --output tsv)
    


