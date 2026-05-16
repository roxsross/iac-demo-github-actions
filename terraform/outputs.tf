# Outputs del proyecto

output "random_value" {
  description = "Valor aleatorio generado (sensible). Verificar con: aws --endpoint-url=http://localhost:4566 ssm get-parameter --name '/<project>-<environment>/random-value' --with-decryption"
  value       = random_string.this.result
  sensitive   = true
}

output "ssm_parameter_name" {
  description = "Nombre del parámetro en SSM. Verificar con: aws --endpoint-url=http://localhost:4566 ssm describe-parameters"
  value       = aws_ssm_parameter.random_value.name
}

