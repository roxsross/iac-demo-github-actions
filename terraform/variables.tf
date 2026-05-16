# Variables del proyecto

variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser dev, staging o prod."
  }
}

variable "random_length" {
  description = "Longitud del string aleatorio generado"
  type        = number
  default     = 16

  validation {
    condition     = var.random_length >= 4 && var.random_length <= 64
    error_message = "La longitud debe estar entre 4 y 64 caracteres."
  }
}
