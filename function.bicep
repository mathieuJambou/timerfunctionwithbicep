// =========== storage.bicep ===========
param location string

param par_hostingPlanFunctionName string
param par_hostingPlanSkuCode string
param par_hostingPlanSku string

param par_FunctionAppName string
param par_javaVersionFunction string

param storageAccountName string
@secure() 
param storageAccountKey string

// ===== Hosting Plans =====
resource res_appserviceplan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: par_hostingPlanFunctionName
  location: location
  properties: {
      reserved: true
  }
  sku: {
      name: par_hostingPlanSkuCode
      tier: par_hostingPlanSku
  }
  kind: 'linux'
}


// ===== Function Apps =====
resource integrationFunctionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: par_FunctionAppName
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: res_appserviceplan.id
    siteConfig: {
      alwaysOn: false
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccountKey}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTION_WORKER_RUNTIME'
          value: 'java'
        }
      ]
      azureStorageAccounts: {}
      minTlsVersion: '1.2'
      linuxFxVersion: par_javaVersionFunction
      numberOfWorkers: 1
      use32BitWorkerProcess: false
    }
  }
}
