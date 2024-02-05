param location string = resourceGroup().location
param mapsLocation string = 'westeurope'
param project string = 'foo'

@description('Azure blob Storage Account resource.')
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: '${project}storage'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: 'default'
  parent: storageAccount
}


@description('Azure storage container resource.')
resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: 'landing'
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}


@description('Azure Search service resource.')
resource searchService 'Microsoft.Search/searchServices@2023-11-01' = {
  name: '${project}-search'
  location: location
  tags: {}
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: 'enabled'
    networkRuleSet: {
      ipRules: []
    }
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
    disableLocalAuth: false
    authOptions: {
      apiKeyOnly: {}
    }
    semanticSearch: 'disabled'
  }
  sku: {
    name: 'basic'
  }
}


@description(
  '''Azure Maps Account resource.
     Note Azure Maps is not available in UK south'''
     )
resource azureMaps 'Microsoft.Maps/accounts@2023-08-01-preview' = {
  kind: 'Gen2'
  sku: {
    name: 'G2'
  }
  properties: {
    disableLocalAuth: false
    cors: {
      corsRules: [
        {
          allowedOrigins: []
        }
      ]
    }
  }
  name: '${project}-azuremaps'
  location: mapsLocation
  identity: {
    type: 'None'
  }
}
