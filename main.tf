# ==============================================
# TERRAFORM - Azure Functions Demo
# Costo estimado: $0.00 (capa gratuita de Azure)
# ==============================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# ==============================================
# RESOURCE GROUP
# ==============================================

resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg"
  location = var.azure_region

  tags = local.common_tags
}

# ==============================================
# STORAGE ACCOUNT
# Necesario para Azure Functions
# ==============================================

resource "azurerm_storage_account" "main" {
  name                     = substr(replace("${var.project_name}store", "-", ""), 0, 24)
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags
}

# ==============================================
# APP SERVICE PLAN
# Y1 = Consumption Plan (serverless)
# ==============================================

resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  os_type  = "Linux"
  sku_name = "Y1"

  tags = local.common_tags
}

# ==============================================
# APPLICATION INSIGHTS
# Observabilidad / logs
# ==============================================

resource "azurerm_application_insights" "main" {
  name                = "${var.project_name}-insights"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  application_type = "Node.JS"

  tags = local.common_tags
}

# ==============================================
# FUNCTION APP — HELLO
# ==============================================

resource "azurerm_linux_function_app" "hello" {

  name                = "${var.project_name}-hello"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key

  service_plan_id = azurerm_service_plan.main.id

  site_config {

    application_stack {
      node_version = "20"
    }

    application_insights_key               = azurerm_application_insights.main.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.main.connection_string
  }

  app_settings = {

    FUNCTIONS_WORKER_RUNTIME = "node"
    FUNCTIONS_EXTENSION_VERSION = "~4"

    ENVIRONMENT = var.environment

    AzureWebJobsFeatureFlags = "EnableWorkerIndexing"

    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"

    WEBSITE_RUN_FROM_PACKAGE = "1"
  }

  tags = local.common_tags
}

# ==============================================
# FUNCTION APP — GOODBYE
# ==============================================

resource "azurerm_linux_function_app" "goodbye" {

  name                = "${var.project_name}-goodbye"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key

  service_plan_id = azurerm_service_plan.main.id

  site_config {

    application_stack {
      node_version = "20"
    }

    application_insights_key               = azurerm_application_insights.main.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.main.connection_string
  }

  app_settings = {

    FUNCTIONS_WORKER_RUNTIME = "node"
    FUNCTIONS_EXTENSION_VERSION = "~4"

    ENVIRONMENT = var.environment

    AzureWebJobsFeatureFlags = "EnableWorkerIndexing"

    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"

    WEBSITE_RUN_FROM_PACKAGE = "1"
  }

  tags = local.common_tags
}

# ==============================================
# CREACIÓN DE LOS ZIP
# Empaqueta el código de cada Function
# ==============================================

data "archive_file" "hello_zip" {

  type        = "zip"

  source_dir  = "${path.module}/functions/hello"
  output_path = "${path.module}/functions/hello/hello.zip"

  excludes = [
    "hello.zip"
  ]
}

data "archive_file" "goodbye_zip" {

  type        = "zip"

  source_dir  = "${path.module}/functions/goodbye"
  output_path = "${path.module}/functions/goodbye/goodbye.zip"

  excludes = [
    "goodbye.zip"
  ]
}

# ==============================================
# DEPLOY HELLO FUNCTION
# Usa Azure CLI para hacer zip deploy
# ==============================================

resource "null_resource" "deploy_hello" {

  triggers = {
    zip_hash = data.archive_file.hello_zip.output_md5
    app_id   = azurerm_linux_function_app.hello.id
  }

  depends_on = [
    azurerm_linux_function_app.hello
  ]

  provisioner "local-exec" {
  command = "az functionapp deployment source config-zip --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_linux_function_app.hello.name} --src ${path.module}/functions/hello/hello.zip --build-remote true"
}
}

# ==============================================
# DEPLOY GOODBYE FUNCTION
# ==============================================

resource "null_resource" "deploy_goodbye" {

  triggers = {
    zip_hash = data.archive_file.goodbye_zip.output_md5
    app_id   = azurerm_linux_function_app.goodbye.id
  }

  depends_on = [
    azurerm_linux_function_app.goodbye
  ]

  provisioner "local-exec" {
  command = "az functionapp deployment source config-zip --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_linux_function_app.goodbye.name} --src ${path.module}/functions/goodbye/goodbye.zip --build-remote true"
}
}