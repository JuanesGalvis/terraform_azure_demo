# ==============================================
# VARIABLES
# ==============================================

variable "azure_region" {
  description = "Región de Azure donde se desplegarán los recursos"
  type        = string
  default     = "East US"
}

variable "project_name" {
  description = "Nombre base del proyecto (prefijo para todos los recursos)"
  type        = string
  default     = "tf-demo"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El entorno debe ser: dev, staging, o prod."
  }
}

# ==============================================
# LOCALS
# ==============================================
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
