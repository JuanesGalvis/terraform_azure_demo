# 🚀 Terraform + Azure Functions Demo

Proyecto de demostración que despliega **dos Azure Functions (Node.js)** usando **Terraform** como infraestructura como código (IaC).

El proyecto incluye:

- Infraestructura en **Azure**
- **2 APIs serverless**
- Empaquetado automático del código
- Deploy mediante **Azure CLI**
- Preparado para **GitHub Actions**

---

# 📁 1. Estructura del proyecto

```
project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
├── functions/
│   ├── hello/
│   │   ├── host.json
│   │   ├── package.json
│   │   ├── package-lock.json
│   │   └── src/
│   │       └── functions/
│   │           └── hello.js
│   │
│   └── goodbye/
│       ├── host.json
│       ├── package.json
│       ├── package-lock.json
│       └── src/
│           └── functions/
│               └── goodbye.js
│
└── .github/
    └── workflows/
        └── deploy.yml (opcional)
```

---

# ⚙️ 2. Instalación de Terraform en Windows

1. Descargar Terraform:

https://developer.hashicorp.com/terraform/downloads

2. Descargar la versión para **Windows AMD64**

3. Extraer el `.zip`

4. Copiar `terraform.exe` en:

```
C:\Terraform\
```

5. Agregar la carpeta al **PATH del sistema**

```
Panel de Control → Sistema → Variables de entorno → Path
```

Agregar:

```
C:\Terraform
```

---

# ☁️ 3. Instalación de Azure CLI en Windows

Descargar desde:

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows

Instalar con el **MSI Installer**.

---

# 🔎 4. Validar instalación

Abrir una terminal y ejecutar:

```bash
terraform -version
```

```bash
az version
```

```bash
node -v
```

Ejemplo esperado:

```
Terraform v1.x.x
azure-cli 2.x.x
v20.x.x
```

---

# 🔐 5. Autenticación con Azure

## Login

```bash
az login
```

Esto abrirá el navegador para autenticación.

---

## Obtener Subscription ID

```bash
az account show
```

Guardar los campos:

```
id
tenantId
```

---

## Crear Service Principal

```bash
az ad sp create-for-rbac \
  --name "terraform-demo-sp" \
  --role "Contributor" \
  --scopes "/subscriptions/TU_SUBSCRIPTION_ID" \
  --sdk-auth
```

Ejemplo de salida JSON:

```json
{
  "clientId": "xxxx",
  "clientSecret": "xxxx",
  "subscriptionId": "xxxx",
  "tenantId": "xxxx",
  "activeDirectoryEndpointUrl": "...",
  "resourceManagerEndpointUrl": "...",
  "activeDirectoryGraphResourceId": "...",
  "sqlManagementEndpointUrl": "...",
  "galleryEndpointUrl": "...",
  "managementEndpointUrl": "..."
}
```

Guardar estos valores:

```
clientId
clientSecret
subscriptionId
tenantId
```

---

# 🔑 6. Configurar variables de Azure para Terraform

Terraform usa variables de entorno.

En Windows PowerShell:

```powershell
$env:ARM_CLIENT_ID="clientId"
$env:ARM_CLIENT_SECRET="clientSecret"
$env:ARM_SUBSCRIPTION_ID="subscriptionId"
$env:ARM_TENANT_ID="tenantId"
```

En CMD:

```cmd
set ARM_CLIENT_ID=clientId
set ARM_CLIENT_SECRET=clientSecret
set ARM_SUBSCRIPTION_ID=subscriptionId
set ARM_TENANT_ID=tenantId
```

---

# 📦 7. Instalar dependencias de las APIs

Ir a cada función.

### Hello API

```bash
cd functions/hello
npm install
```

### Goodbye API

```bash
cd ../goodbye
npm install
```

Volver al directorio raíz:

```bash
cd ../../
```

---

# 🏗 8. Comandos de Terraform

Inicializar Terraform:

```bash
terraform init
```

Ver plan de infraestructura:

```bash
terraform plan
```

Crear infraestructura y desplegar APIs:

```bash
terraform apply
```

Terraform pedirá confirmación:

```
Enter a value: yes
```

---

## Eliminar infraestructura

```bash
terraform destroy
```

---

# 🌐 9. Probar las APIs

Después del `terraform apply`, Terraform mostrará las URLs.

Ejemplo:

```
hello_function_url
goodbye_function_url
```

Probar con `curl`.

### Hello API

```bash
curl https://tf-demo-hello.azurewebsites.net/api/hello
```

Respuesta esperada:

```
Hello from Azure Function 🚀
```

---

### Goodbye API

```bash
curl https://tf-demo-goodbye.azurewebsites.net/api/goodbye
```

Respuesta esperada:

```
Goodbye from Azure Function 👋
```

---

# 🔐 10. Configuración de Secrets en GitHub (opcional)

Si deseas automatizar el despliegue con **GitHub Actions**, agregar estos secrets en el repositorio.

Ir a:

```
GitHub → Settings → Secrets → Actions
```

Agregar:

```
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID
ARM_TENANT_ID
```

Estos valores provienen del **Service Principal creado anteriormente**.

---

# ☁️ 11. Recursos creados en Azure

Terraform crea los siguientes recursos:

| Recurso                      | Descripción                    |
| ---------------------------- | ------------------------------ |
| Resource Group               | Contenedor de recursos         |
| Storage Account              | Requerido para Azure Functions |
| Service Plan (Y1)            | Plan serverless (Consumption)  |
| Application Insights         | Logs y monitoreo               |
| Azure Function App (hello)   | API serverless                 |
| Azure Function App (goodbye) | API serverless                 |

Todos los recursos se crean dentro del **Resource Group definido en Terraform**.

---

# 💰 Costo estimado

Este proyecto usa:

- **Azure Functions Consumption Plan**
- **Application Insights básico**
- **Storage Account Standard**

En uso mínimo normalmente entra en la **capa gratuita de Azure**.

---

# 📚 Tecnologías utilizadas

- Terraform
- Azure Functions
- Azure CLI
- Node.js
- GitHub Actions (opcional)

---

# 👨‍💻 Autor

Demo educativa para aprender:

- Infrastructure as Code
- Serverless
- DevOps con Terraform
- Azure Functions

---
