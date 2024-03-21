# Using Azure Functions
We can use serverless Azure functions to implement custom skills in the indexing pipeline, and also for other application logic in the solution. 

(TODO -> add link to architecture diagram)

## Functions development environment

This repo assumes that the functions core dev tools are installed at version 4.0.1 or later. 

> Recommendation: on WSL ubuntu, install and use node v16 using nvm and then install func core tools

- Installation and usage guide: [Develop locally with Azure Functions core tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local)

Verify installation
```bash
func --version
```

## Set up a function app

a function app can hold multiple functions, but will have common settings and configuration, so it makes sense to create separate function apps for different purposes.

create a folder to hold the function app
```bash
cd functions
mkdir $MY_FUNCTION_APP_NAME
cd $MY_FUNCTION_APP_NAME
```



## set up a local virtual environmet
from within the funciton app folder:

first ensure venv is installed
```
sudo apt-get update
sudo apt install python3-venv

```
then create a virtual environment and activate
```bash
python3 -m venv .venv   
source .venv/bin/activate
```

verify
```bash
which python
python --version
```

Update the requirements.txt file with the packages you need for your function app (this may need iteration)
```bash
pip install -r requirements.txt
```


## Initialise a python function app

We will use the v2 python programming model (see [here](https://techcommunity.microsoft.com/t5/azure-compute-blog/azure-functions-v2-python-programming-model-is-generally/ba-p/3827474) and [here](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-python?pivots=python-mode-decorators&tabs=linux%2Cbash%2Cazure-cli) for details).
    
the `--python` option sets the v2 programming model

```bash
func init --python
```


## Create a function

```bash
func new [--name sample-function] [--template "HTTP trigger"] [--authlevel "anonymous"]
```
or just run func new and choose interactively
- template: HTTP trigger
- function name: $MY_FUNCTION_NAME

this will create a file named 'function_app.py' in the function app folder, with a function named $MY_FUNCTION_NAME

## set up storage backing the local emulator
add a storage account connection string in the local.settings.json file, or look into using azurite for local storage emulation

```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": [connection string here, or set to "UseDevelopmentStorage=true" for azurite emulation],
    "FUNCTIONS_WORKER_RUNTIME": "python"
  }
}
```json

## Run the function locally

start a local emulator to open up an endpoint for each function in the function app - so you can trigger the function (for HTTP triggers, for example)
```bash
func start
```
> Note: ignore the warning that 'Customer packages are not in sys path'

# Develop a function for calling the Azure OpenAI service
see this resource for examples
https://learn.microsoft.com/en-us/samples/azure-samples/azure-functions-python-openai-sdk/azure-functions-python-use-open-ai/



## Deploy the function app to Azure
For deployment, we have to have a function app resource in Azure. 
For now, we will use the Azure CLI to create the function app. We can add this to the bicep templates later (TODO).
> the following snippet is from  https://learn.microsoft.com/en-us/azure/azure-functions/scripts/functions-cli-create-serverless-python

```bash

# Variable block
location="uksouth"
resourceGroup="rrfidemo"
tag="create-function-app-consumption-python"
storage="rrfidemostorage"
functionApp="indexer-functions-py"
functionsVersion="4"
pythonVersion="3.8" #Allowed values: 3.7, 3.8, and 3.9

# Optional - create basic plan
az appservice plan create -g $resourceGroup -n UKSouthLinuxB1Plan --is-linux --number-of-workers 1 --sku B1 --location $location


# Create a serverless python function app in the resource group.
az functionapp create --name $functionApp-B1 --storage-account $storage --resource-group $resourceGroup --os-type Linux --runtime python --runtime-version $pythonVersion --functions-version $functionsVersion --plan UKSouthLinuxB1Plan
# --consumption-plan-location "$location"
```



Then publish the local function app to the function app resource


Then publish 
```bash
func azure functionapp publish $functionApp
```

```bash
func azure functionapp publish $functionApp --publish-settings-only
```
