// =========== storage.bicep ===========
param location string 
param storageAccountName string

resource storage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}


output key string = storage.listKeys().keys[0].value
output name string = storage.name
