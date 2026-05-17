# IaC Demo — GitHub Actions + Terraform + LocalStack

Repositorio de demostración que implementa Infrastructure as Code (IaC) con Terraform, usando LocalStack (MiniStack) como backend local de AWS, y GitHub Actions para automatización de documentación.

## ¿Qué hace este proyecto?

1. Genera un string aleatorio configurable.
2. Almacena ese valor como `SecureString` en AWS SSM Parameter Store.
3. Usa LocalStack para emular los servicios de AWS localmente (sin costos ni cuenta real).
4. Automatiza la generación de documentación con Kiro CLI vía GitHub Actions.

## Estructura del repositorio

```
.
├── README.md                    # Este archivo
├── docs/
│   └── README.md                # Documentación técnica detallada de Terraform
├── terraform/
│   ├── versions.tf              # Versiones de Terraform y providers
│   ├── providers.tf             # Provider AWS apuntando a LocalStack
│   ├── variables.tf             # Variables de entrada
│   ├── locals.tf                # Valores locales calculados
│   ├── main.tf                  # Recursos principales
│   ├── outputs.tf               # Outputs del proyecto
│   └── terraform.tfvars         # Valores por defecto (ambiente dev)
├── .github/
│   └── workflows/
│       └── main.yml             # CI/CD: generación automática de docs
├── .gitignore
└── terraform.excalidraw         # Diagrama de arquitectura
```

## Inicio rápido

### Pre-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.6.0
- [Docker](https://docs.docker.com/get-docker/) con LocalStack corriendo en el puerto 4566

### Levantar LocalStack

```bash
docker run -d --name localstack -p 4566:4566 localstack/localstack
```

### Desplegar la infraestructura

```bash
cd terraform
terraform init
terraform apply
```

### Verificar

```bash
aws --endpoint-url=http://localhost:4566 ssm get-parameter \
  --name '/kiro-roxs-demo-dev/random-value' --with-decryption
```

## CI/CD

El workflow `.github/workflows/main.yml` se ejecuta en cada push a `main` (excluyendo cambios en docs) y:

1. Instala Kiro CLI.
2. Ejecuta el agente `doc-generator` para escanear el repo y actualizar la documentación.
3. Si hay cambios, crea una rama `docs/auto-update-*` y hace push.

Requiere el secret `KIRO_API_KEY` configurado en el repositorio.

## Documentación detallada

Consulta [docs/README.md](docs/README.md) para la referencia técnica completa de la configuración Terraform.
