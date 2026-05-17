# Terraform — Referencia Técnica

Documentación detallada de la configuración Terraform del proyecto. Genera un string aleatorio y lo almacena en AWS SSM Parameter Store usando LocalStack como backend local.

## Estructura de archivos

| Archivo            | Descripción                                      |
|--------------------|--------------------------------------------------|
| `versions.tf`      | Versiones de Terraform y providers requeridos    |
| `providers.tf`     | Configuración del provider AWS (LocalStack)      |
| `variables.tf`     | Declaración de variables de entrada              |
| `locals.tf`        | Tags comunes y prefijo de nombres                |
| `main.tf`          | Recursos: `random_string` + `aws_ssm_parameter` |
| `outputs.tf`       | Outputs con valores y comandos de verificación   |
| `terraform.tfvars` | Valores por defecto para el ambiente dev         |

## Providers

| Provider          | Versión  | Fuente            |
|-------------------|----------|--------------------|
| `hashicorp/aws`   | `~> 5.0` | registry.terraform.io |
| `hashicorp/random`| `~> 3.6` | registry.terraform.io |

El provider AWS está configurado para apuntar a LocalStack (`http://localhost:4566`) con credenciales de prueba (`test`/`test`). Los endpoints configurados incluyen: S3, SQS, SNS, DynamoDB, IAM, STS, Secrets Manager, SSM, CloudWatch Logs y Lambda.

## Variables

| Variable        | Tipo     | Default | Descripción                                      | Validación                          |
|-----------------|----------|---------|--------------------------------------------------|-------------------------------------|
| `project`       | `string` | —       | Nombre del proyecto                              | —                                   |
| `environment`   | `string` | —       | Ambiente de despliegue                           | Debe ser `dev`, `staging` o `prod`  |
| `random_length` | `number` | `16`    | Longitud del string aleatorio generado           | Entre 4 y 64 caracteres             |

### Valores por defecto (`terraform.tfvars`)

```hcl
project       = "kiro-roxs-demo"
environment   = "dev"
random_length = 24
```

## Locals

```hcl
locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
  name_prefix = "${var.project}-${var.environment}"
}
```

- `common_tags`: Tags aplicados a todos los recursos y como `default_tags` del provider.
- `name_prefix`: Prefijo para nombrar recursos, con formato `<project>-<environment>`.

## Recursos

### `random_string.this`

Genera un string aleatorio con letras mayúsculas, minúsculas y números (sin caracteres especiales).

- Longitud controlada por `var.random_length` (default: 16, override en tfvars: 24).

### `aws_ssm_parameter.random_value`

Almacena el string generado como `SecureString` en SSM Parameter Store.

- **Nombre**: `/${local.name_prefix}/random-value` → `/kiro-roxs-demo-dev/random-value`
- **Tipo**: `SecureString`
- **Tags**: `common_tags`

## Outputs

| Output               | Sensible | Descripción                              |
|----------------------|----------|------------------------------------------|
| `random_value`       | Sí       | Valor aleatorio generado                 |
| `ssm_parameter_name` | No       | Nombre completo del parámetro en SSM     |

## Pre-requisitos

- Terraform >= 1.6.0
- Docker con LocalStack corriendo en el puerto 4566

```bash
docker run -d --name localstack -p 4566:4566 localstack/localstack
```

Verificar que LocalStack esté activo:

```bash
docker ps | grep localstack
```

## Uso

```bash
cd terraform
terraform init
terraform apply
```

Para personalizar los valores:

```bash
terraform apply -var="project=mi-proyecto" -var="environment=staging" -var="random_length=32"
```

## Verificación

Consultar el parámetro almacenado:

```bash
aws --endpoint-url=http://localhost:4566 ssm get-parameter \
  --name '/kiro-roxs-demo-dev/random-value' --with-decryption
```

Listar todos los parámetros:

```bash
aws --endpoint-url=http://localhost:4566 ssm describe-parameters
```

Ver el output sensible desde Terraform:

```bash
terraform output random_value
```

## CI/CD — Generación automática de documentación

El workflow en `.github/workflows/main.yml` automatiza la actualización de esta documentación:

- **Trigger**: Push a `main` (ignora cambios en `docs/`, `*.md` y `.github/`).
- **Acción**: Ejecuta Kiro CLI con el agente `doc-generator`.
- **Resultado**: Si hay cambios, crea una rama `docs/auto-update-<timestamp>` y hace push.
- **Requisito**: Secret `KIRO_API_KEY` configurado en el repositorio de GitHub.
- **Timeout**: 15 minutos.
- **Permisos**: `contents: write` para poder crear ramas y hacer push.
