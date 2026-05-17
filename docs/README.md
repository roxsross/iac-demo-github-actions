# Terraform — Random + SSM Parameter Store

Proyecto simple que genera un string aleatorio y lo almacena en AWS SSM Parameter Store usando MiniStack (LocalStack) como backend local.

## Estructura

| Archivo          | Descripción                                      |
|------------------|--------------------------------------------------|
| `versions.tf`    | Versiones de Terraform y providers requeridos    |
| `providers.tf`   | Configuración del provider AWS (MiniStack)       |
| `variables.tf`   | Declaración de variables                         |
| `locals.tf`      | Tags comunes y prefijo de nombres                |
| `main.tf`        | Recursos: random_string + aws_ssm_parameter      |
| `outputs.tf`     | Outputs con comandos de verificación             |
| `terraform.tfvars` | Valores por defecto para el ambiente dev       |

## Pre-requisitos

- Terraform >= 1.6.0
- Docker con MiniStack corriendo en el puerto 4566

Verificar que MiniStack esté activo:

```bash
docker ps | grep ministack
```

## Uso

```bash
terraform init
terraform apply
```

## Verificación

Consultar el parámetro almacenado:

```bash
aws --endpoint-url=http://localhost:4566 ssm get-parameter \
  --name '/kiro-demo-dev/random-value' --with-decryption
```

Listar todos los parámetros:

```bash
aws --endpoint-url=http://localhost:4566 ssm describe-parameters
```
