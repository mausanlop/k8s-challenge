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
<img width="894" height="87" alt="image" src="https://github.com/user-attachments/assets/d7951d75-4077-4068-a9d6-5465ae4f9cf8" />




b. Instación y validación de "kubectl"


---

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
