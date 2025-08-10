# K8s Challenge
### El siguiente repositorio contiene un despliegue básico de una aplicación web en un cluster de kubernetes, usando herramientas de Google Cloud Platform (GCP) como GKE y Cloud SQL, además de monitoreo con Prometheus y Grafana. 

# ⚙️ Premisas y Requisitos para Ejecutar el Proyecto

## ✅ 1. Requisitos de cuentas y servicios en la nube

### Google Cloud Platform (GCP)
- Cuenta activa en Google Cloud con facturación habilitada.
- Proyecto creado en GCP.
- Habilitar las siguientes APIs en el proyecto de GCP:
  - Kubernetes Engine API
  - Cloud SQL Admin API
  - Compute Engine API
  - Artifact Registry


Comandos para habilitar APIs en el proyecto de GCP:
```bash
gcloud services enable container.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

---

## ✅ 2. Requisitos en equipo local (en este ejemplo MacOS)

### Software necesario:
| Herramienta      | Propósito                             | Comando sugerido o enlace                    |
|------------------|----------------------------------------|----------------------------------------------|
| Docker           | Construcción local de imágenes         | [docker.com](https://www.docker.com)         |
| gcloud CLI       | Interacción con GCP                    | `brew install --cask google-cloud-sdk`       |
| kubectl          | Gestión de recursos de GKE             | `gcloud components install kubectl`          |
| mysql-client     | Conexión a base de datos Cloud SQL     | `brew install mysql-client`                  |
| helm             | Instalación de Prometheus y Grafana    | `brew install helm`                          |


a. Instalación y validación de "gcloud CLI"
```bash
brew install --cask google-cloud-sdk
gcloud init
gcloud auth login
gcloud version
````

```
acoca@K8s gke-challenge % gcloud version                   
Google Cloud SDK 533.0.0

```
b. Instalación y validación de "kubectl"
```
gcloud components install kubectl
```

```
acoca@K8s gke-challenge % kubectl version
Client Version: v1.33.3
Kustomize Version: v5.6.0
Server Version: v1.33.2-gke.1240000
```
c. Instalación y validación de "mysql-client"

```
brew install mysql-client
brew list mysql-client
```

```
acoca@K8s gke-challenge % brew list mysql-client
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/comp_err
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/my_print_defaults
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysql
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysql_config
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysql_config_editor
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysql_migrate_keyring
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysql_secure_installation
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysqladmin
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysqlbinlog
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysqlcheck
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysqldump
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysqlimport
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysqlshow
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysqlslap
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/mysqltest
/opt/homebrew/Cellar/mysql-client/9.4.0/bin/perror
/opt/homebrew/Cellar/mysql-client/9.4.0/include/mysql/ (13 files)
/opt/homebrew/Cellar/mysql-client/9.4.0/lib/libmysqlclient.24.dylib
/opt/homebrew/Cellar/mysql-client/9.4.0/lib/pkgconfig/mysqlclient.pc
/opt/homebrew/Cellar/mysql-client/9.4.0/lib/plugin/ (5 files)
/opt/homebrew/Cellar/mysql-client/9.4.0/lib/ (2 other files)
/opt/homebrew/Cellar/mysql-client/9.4.0/sbom.spdx.json
/opt/homebrew/Cellar/mysql-client/9.4.0/share/doc/ (2 files)
/opt/homebrew/Cellar/mysql-client/9.4.0/share/man/ (27 files)
/opt/homebrew/Cellar/mysql-client/9.4.0/share/mysql/ (53 files)
```
d. Instalación y validación de "Helm"

```
brew install helm
helm version
```
```
acoca@K8s gke-challenge % helm version
version.BuildInfo{Version:"v3.18.4", GitCommit:"d80839cf37d860c8aa9a0503fe463278f26cd5e2", GitTreeState:"clean", GoVersion:"go1.24.5"}
```

## ✅ 3. Recursos necesarios en GCP

1. Clúster GKE creado y accesible:
```bash
gcloud container clusters create my-gke-cluster   --zone us-central1-c   --num-nodes 3
gcloud container clusters get-credentials my-gke-cluster --zone us-central1-c
```

2. Instancia MySQL en Cloud SQL:
```bash
gcloud sql instances create my-mysql   --database-version=MYSQL_8_0   --tier=db-g1-small   --region=us-central1

gcloud sql users set-password root --host=% --instance=my-mysql --password=example

gcloud sql databases create login_db --instance=my-mysql
```

3. Obtener IP pública de Cloud SQL:
```bash
gcloud sql instances describe my-mysql --format="value(ipAddresses.ipAddress)"
```

4. Habilitar acceso desde GKE:
```bash
gcloud sql instances patch my-mysql --authorized-networks=<GKE_NODE_IP>/32
```

---

## ✅ 4. Permisos requeridos

- Autenticación:
```bash
gcloud auth login
gcloud config set project <PROJECT_ID>
```

---

## 📘 Documentación: PHP Login App en GKE + Cloud SQL

## 📌 Descripción

Aplicación de login simple en PHP con autenticación básica y conexión a Cloud SQL (MySQL), desplegada en GKE usando Docker.

---

## 📁 Estructura del Proyecto

```bash
mkdir php-login-app
cd php-login-app
touch db.php index.php dashboard.php logout.php Dockerfile .dockerignore php-login-deployment.yaml
mkdir docs
```

---

## 🐳 Docker Build y Push

```bash
docker buildx build   --platform linux/amd64   -t gcr.io/msl-gke-challenge-prod/php-login-app:latest   --push .
```

---

## ☁️ Despliegue en GKE

```bash
kubectl apply -f php-login-deployment.yaml
kubectl rollout restart deployment php-login-app
```

Ver estado:
```bash
kubectl get pods -o wide
kubectl get svc
kubectl logs <pod-name>
kubectl exec -it <pod-name> -- bash
```

---

## 📊 Monitoreo con Helm, Prometheus y Grafana

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack
```

Acceso a Grafana:
```bash
kubectl port-forward svc/monitoring-grafana 3000:80


URL: [http://localhost:3000](http://localhost:3000)  
Usuario: `admin`  
Password:
```bash
kubectl get secret monitoring-grafana   -o jsonpath="{.data.admin-password}" | base64 -d
