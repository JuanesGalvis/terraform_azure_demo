# ==============================================
# OUTPUTS
# ==============================================

output "hello_function_url" {
  description = "URL para invocar la función Hello via HTTP"
  value       = "https://${azurerm_linux_function_app.hello.default_hostname}/api/hello"
}

output "goodbye_function_url" {
  description = "URL para invocar la función Goodbye via HTTP"
  value       = "https://${azurerm_linux_function_app.goodbye.default_hostname}/api/goodbye"
}

output "hello_app_name" {
  description = "Nombre de la Function App Hello"
  value       = azurerm_linux_function_app.hello.name
}

output "goodbye_app_name" {
  description = "Nombre de la Function App Goodbye"
  value       = azurerm_linux_function_app.goodbye.name
}

output "resource_group" {
  description = "Resource Group que contiene todos los recursos"
  value       = azurerm_resource_group.main.name
}

output "test_hello_command" {
  description = "Comando curl para probar la función Hello"
  value       = "curl \"https://${azurerm_linux_function_app.hello.default_hostname}/api/hello?nombre=TuNombre\""
}

output "test_goodbye_command" {
  description = "Comando curl para probar la función Goodbye"
  value       = "curl \"https://${azurerm_linux_function_app.goodbye.default_hostname}/api/goodbye?nombre=TuNombre\""
}
