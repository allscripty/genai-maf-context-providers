// Infrastructure for GenAI MAF Context Providers Workshop
// Deploys AI Services account with model deployments for shared workshop use

@minLength(1)
@maxLength(64)
@description('Environment name used to generate unique resource names')
param environmentName string

@description('Location for all resources')
param location string = resourceGroup().location

// Chat completion models (gpt-5-nano primary, gpt-5-mini secondary)
@description('Name of the primary chat model to deploy')
param chatModelName string = 'gpt-5-nano'
@description('Version of the primary chat model to deploy')
param chatModelVersion string = '2025-08-07'
@description('SKU for the primary chat deployment')
param chatDeploymentSku string = 'GlobalStandard'
@description('Capacity for the primary chat deployment (TPM in thousands)')
param chatDeploymentCapacity int = 120

@description('Name of the secondary chat model to deploy')
param chatModelMiniName string = 'gpt-5-mini'
@description('Version of the secondary chat model to deploy')
param chatModelMiniVersion string = '2025-08-07'
@description('SKU for the secondary chat deployment')
param chatDeploymentMiniSku string = 'GlobalStandard'
@description('Capacity for the secondary chat deployment (TPM in thousands)')
param chatDeploymentMiniCapacity int = 120

// Embedding model - must match pre-computed embeddings in movie_embeddings.csv
@description('Name of the embedding model to deploy')
param embeddingModelName string = 'text-embedding-ada-002'
@description('Version of the embedding model to deploy')
param embeddingModelVersion string = '2'
@description('SKU for the embedding deployment')
param embeddingDeploymentSku string = 'GlobalStandard'
@description('Capacity for the embedding deployment')
param embeddingDeploymentCapacity int = 120

var tags = { 'azd-env-name': environmentName }
var resourceToken = toLower(uniqueString(resourceGroup().id, environmentName))

// AI Services account
resource aiServices 'Microsoft.CognitiveServices/accounts@2025-09-01' = {
  name: 'ai-${resourceToken}'
  location: location
  tags: tags
  kind: 'AIServices'
  sku: { name: 'S0' }
  properties: {
    customSubDomainName: 'ai-${resourceToken}'
    publicNetworkAccess: 'Enabled'
  }
}

// Primary chat model deployment (gpt-5-nano)
resource chatDeployment 'Microsoft.CognitiveServices/accounts/deployments@2025-09-01' = {
  parent: aiServices
  name: chatModelName
  properties: {
    model: {
      format: 'OpenAI'
      name: chatModelName
      version: chatModelVersion
    }
    versionUpgradeOption: 'NoAutoUpgrade'
  }
  sku: {
    name: chatDeploymentSku
    capacity: chatDeploymentCapacity
  }
}

// Secondary chat model deployment (gpt-5-mini)
resource chatMiniDeployment 'Microsoft.CognitiveServices/accounts/deployments@2025-09-01' = {
  parent: aiServices
  name: chatModelMiniName
  dependsOn: [chatDeployment] // Deploy sequentially to avoid conflicts
  properties: {
    model: {
      format: 'OpenAI'
      name: chatModelMiniName
      version: chatModelMiniVersion
    }
    versionUpgradeOption: 'NoAutoUpgrade'
  }
  sku: {
    name: chatDeploymentMiniSku
    capacity: chatDeploymentMiniCapacity
  }
}

// Embedding model deployment (text-embedding-ada-002)
resource embeddingDeployment 'Microsoft.CognitiveServices/accounts/deployments@2025-09-01' = {
  parent: aiServices
  name: embeddingModelName
  dependsOn: [chatMiniDeployment] // Deploy sequentially to avoid conflicts
  properties: {
    model: {
      format: 'OpenAI'
      name: embeddingModelName
      version: embeddingModelVersion
    }
    versionUpgradeOption: 'NoAutoUpgrade'
  }
  sku: {
    name: embeddingDeploymentSku
    capacity: embeddingDeploymentCapacity
  }
}

// Outputs
output AZURE_RESOURCE_GROUP string = resourceGroup().name
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_AI_SERVICES_ENDPOINT string = aiServices.properties.endpoint
output AZURE_AI_SERVICES_NAME string = aiServices.name
output AZURE_AI_MODEL_NAME string = chatDeployment.name
output AZURE_AI_MODEL_MINI_NAME string = chatMiniDeployment.name
output AZURE_AI_EMBEDDING_NAME string = embeddingDeployment.name
