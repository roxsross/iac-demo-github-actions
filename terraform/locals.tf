# Valores calculados locales

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  # Nombre base para recursos
  name_prefix = "${var.project}-${var.environment}"
}
