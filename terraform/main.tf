# Recurso principal: genera un string aleatorio y lo almacena en SSM Parameter Store

# Generador de string aleatorio
resource "random_string" "this" {
  length  = var.random_length
  special = false
  upper   = true
  lower   = true
  numeric = true
}

# Almacena el valor aleatorio en SSM Parameter Store
resource "aws_ssm_parameter" "random_value" {
  name  = "/${local.name_prefix}/random-value"
  type  = "SecureString"
  value = random_string.this.result

  tags = local.common_tags
}
