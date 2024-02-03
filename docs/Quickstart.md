## Deploy Azure Resources

This demo uses Azure Bicep to deploy the required infrastructure

Log into Azure using the Azure CLI

```bash    
az login [--tenant TENANT_ID]
```

Deploy the resources using the following command

```bash    
cd ./infrastructure/bicep
bash deploy.sh
```

> TODO: capture environment variables in a .env file after deployment

## Configure VSCode Rest Client

This demo uses the VSCode Rest Client extension as the management plane for Azure AI Search configuration and testing.

Add the [Rest Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) extension to VSCode.
Create a file named .vscode/settings.json or add to it if it doesn't exist. 

Add the following to the file, replacing all values starting `YOUR_` in the snippet below with your own values. 

```json
{
    "rest-client.environmentVariables": {
        "YOUR_env_name": {
            "env-search-name": "YOUR-azure-ai-search-name",
            "env-search-api-key": "YOUR-azure-ai-search-key"
        }
    }
}
```

## Configure Azure AI Search

### Push pattern
Run through the following sequentially:

- ../search/management/manage-index.rest
- ../search/management/manage-push-data-bulk.rest

### Pull pattern
Run through the following sequentially:
- ../search/management/manage-index.rest
- ../search/management/manage-datasource.rest
- ../search/management/manage-indexer.rest
```
