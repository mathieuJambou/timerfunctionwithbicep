// =========== main.bicep ===========

// Setting target scope
targetScope = 'subscription'

param location string = 'westus'

// Creating resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'rg-mjtestfunc'
  location: location
}

// Deploying storage account using module
module stg './storage.bicep' = {
  name: 'storage'  
  scope: rg    // Deployed in the scope of resource group we created above
  params: {
    location: location
    storageAccountName: 'mjstoragefunctimer'
  }
}

// Deploying function using module
module fct './function.bicep' = {
  name: 'function'
  scope: rg    // Deployed in the scope of resource group we created above
  params: {
    location: location
    par_hostingPlanFunctionName: 'plan-mjtest-hosting'
    par_hostingPlanSkuCode: 'S1'
    par_hostingPlanSku: 'Standard'
    par_FunctionAppName: 'mjtest-func-timer'
    par_javaVersionFunction: 'Java|11'
    storageAccountName: stg.outputs.name
    storageAccountKey: stg.outputs.key
  }
}

