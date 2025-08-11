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
e. Validación de instalación de Docker
```
docker version
````
```
acoca@K8s gke-challenge % docker version
Client:
 Version:           28.3.2
 API version:       1.51
 Go version:        go1.24.5
 Git commit:        578ccf6
 Built:             Wed Jul  9 16:12:57 2025
 OS/Arch:           darwin/arm64
 Context:           desktop-linux

Server: Docker Desktop 4.43.2 (199162)
 Engine:
  Version:          28.3.2
  API version:      1.51 (minimum version 1.24)
  Go version:       go1.24.5
  Git commit:       e77ff99
  Built:            Wed Jul  9 16:13:56 2025
  OS/Arch:          linux/arm64
  Experimental:     false
 containerd:
  Version:          1.7.27
  GitCommit:        05044ec0a9a75232cad458027ca83437aae3f4da
 runc:
  Version:          1.2.5
  GitCommit:        v1.2.5-0-g59923ef
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
  ````


---

## ✅ 3. Recursos necesarios en GCP

1. Creacion de proyecto en GCP
```
gcloud projects create  gke-challenge-msl
```
```
acoca@K8s gke-challenge % gcloud projects  create gke-challenge-msl
Create in progress for [https://cloudresourcemanager.googleapis.com/v1/projects/gke-challenge-msl].
Waiting for [operations/create_project.global.9159840548868572380] to finish...done.                                                                                     
Enabling service [cloudapis.googleapis.com] on project [gke-challenge-msl]...
Operation "operations/acat.p2-669243478909-a6a7bd30-c97c-4786-9917-5c5d39b46e27" finished successfully.
```
a. Validar y habilitar cuenta de facuración al proyecto de GCP
```
cloud alpha billing accounts list
```
```
acoca@K8s gke-challenge % gcloud alpha billing accounts list
ACCOUNT_ID            NAME                      OPEN  MASTER_ACCOUNT_ID
0144E4-4F81E0-26C456  Mi cuenta de facturación  True
```
```
gcloud beta billing projects link gke-challenge-msl  --billing-account=0144E4-4F81E0-26C456 
````

```
acoca@K8s gke-challenge %     gcloud beta billing projects link gke-challenge-msl  --billing-account=0144E4-4F81E0-26C456 
billingAccountName: billingAccounts/0144E4-4F81E0-26C456
billingEnabled: true
name: projects/gke-challenge-msl/billingInfo
projectId: gke-challenge-msl
```

2. Habilitar API en el proyecto de GCP

a. Validar nombre de proyecto en uso
```
gcloud config get-value project
gcloud config set project gke-challenge-msl 
```
```
acoca@K8s gke-challenge % gcloud config get-value project 
(unset)
acoca@K8s gke-challenge % gcloud config set project gke-challenge-msl
Updated property [core/project].
acoca@K8s gke-challenge % gcloud config get-value project        
gke-challenge-msl
```
b. Comandos para habilitar API´s en el proyecto de GCP 

````
gcloud services enable container.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```
```
acoca@K8s gke-challenge % gcloud services list
NAME                                TITLE
analyticshub.googleapis.com         Analytics Hub API
artifactregistry.googleapis.com     Artifact Registry API
autoscaling.googleapis.com          Cloud Autoscaling API
bigquery.googleapis.com             BigQuery API
bigqueryconnection.googleapis.com   BigQuery Connection API
bigquerydatapolicy.googleapis.com   BigQuery Data Policy API
bigquerymigration.googleapis.com    BigQuery Migration API
bigqueryreservation.googleapis.com  BigQuery Reservation API
bigquerystorage.googleapis.com      BigQuery Storage API
cloudapis.googleapis.com            Google Cloud APIs
cloudtrace.googleapis.com           Cloud Trace API
compute.googleapis.com              Compute Engine API
container.googleapis.com            Kubernetes Engine API
containerfilesystem.googleapis.com  Container File System API
containerregistry.googleapis.com    Container Registry API
dataform.googleapis.com             Dataform API
dataplex.googleapis.com             Cloud Dataplex API
datastore.googleapis.com            Cloud Datastore API
dns.googleapis.com                  Cloud DNS API
gkebackup.googleapis.com            Backup for GKE API
iam.googleapis.com                  Identity and Access Management (IAM) API
iamcredentials.googleapis.com       IAM Service Account Credentials API
logging.googleapis.com              Cloud Logging API
monitoring.googleapis.com           Cloud Monitoring API
networkconnectivity.googleapis.com  Network Connectivity API
oslogin.googleapis.com              Cloud OS Login API
pubsub.googleapis.com               Cloud Pub/Sub API
servicemanagement.googleapis.com    Service Management API
serviceusage.googleapis.com         Service Usage API
sql-component.googleapis.com        Cloud SQL
sqladmin.googleapis.com             Cloud SQL Admin API
storage-api.googleapis.com          Google Cloud Storage JSON API
storage-component.googleapis.com    Cloud Storage
storage.googleapis.com              Cloud Storage API
acoca@K8s gke-challenge % 
````
2. Creación de repositorio artifact registry en GCP 
```
gcloud artifacts repositories create gke-challenge-msl \
  --repository-format=docker \
  --location=us-central1 \
  --description="gke-challenge-msl" 
  ```
  ```
  acoca@K8s gke-challenge % gcloud artifacts repositories create gke-challenge-msl \
  --repository-format=docker \
  --location=us-central1 \
  --description="gke-challenge-msl"
Create request issued for: [gke-challenge-msl]
Waiting for operation [projects/gke-challenge-msl/locations/us-central1/operations/0e558e2e-41ab-4ab5-a41d-021443b67331] to complete...done.                             
Created repository [gke-challenge-msl].
```
```
3. Creación de cluster GKE en GCP
```
gcloud container clusters create gke-challenge-msl \
  --zone us-central1-a \
  --num-nodes 1

  gcloud container clusters list 
  ```
acoca@K8s gke-challenge % gcloud container clusters list                                                
NAME               LOCATION       MASTER_VERSION      MASTER_IP       MACHINE_TYPE  NODE_VERSION        NUM_NODES  STATUS   STACK_TYPE
gke-challenge-msl  us-central1-a  1.33.2-gke.1240000  35.192.113.196  e2-medium     1.33.2-gke.1240000  1          RUNNING  IPV4
```
4. Creación de instancia MySQL en Cloud SQL:
```
gcloud sql instances create gke-challenge-msl \
    --database-version=MYSQL_8_0 \
    --region=us-central1 \
    --tier=db-g1-small \
    --storage-type=SSD \
    --storage-size=10GB
gcloud sql instances describe gke-challenge-msl
```
```
Creating Cloud SQL instance for MYSQL_8_0...done.                                                                                                        Created [https://sqladmin.googleapis.com/sql/v1beta4/projects/gke-challenge-msl/instances/gke-challenge-msl].
NAME               DATABASE_VERSION  LOCATION       TIER         PRIMARY_ADDRESS  PRIVATE_ADDRESS  STATUS
gke-challenge-msl  MYSQL_8_0         us-central1-c  db-g1-small  35.184.41.235    -                RUNNABLE 
```
a. Configurando usuario y contraseña para la instancia MySQL en Cloud SQL
```
gcloud sql users set-password root --host=% --instance=gke-challenge-msl --password=example
```
b. Validando conexión a la instacia de Cloud SQL
```
acoca@K8s gke-challenge % gcloud sql connect gke-challenge-msl  --user=root     
Allowlisting your IP for incoming connection for 5 minutes...done.                                                                                                      
Connecting to database with SQL user [root].Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 393
Server version: 8.0.41-google (Google)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```
c. Creando la base de datos de prueba y tabla de usuarios

```
mysql> CREATE DATABASE login_db;
```
Query OK, 1 row affected (0.063 sec)
```
mysql> USE login_db;
```
```
Database changed
```
``` 
mysql>  CREATE TABLE users (
         ->   id INT AUTO_INCREMENT PRIMARY KEY,
         ->   username VARCHAR(50) NOT NULL,
         ->   password VARCHAR(50) NOT NULL
         -> );
```
```
Query OK, 0 rows affected (0.083 sec)
```

```
mysql> INSERT INTO users (username, password) VALUES ('ng-voice', 'challenge');
```
```
Query OK, 1 row affected (0.066 sec)
```

```
mysql> SELECT * FROM users;
```
```
+----+----------+-----------+
| id | username | password  |
+----+----------+-----------+
|  1 | ng-voice | challenge |
+----+----------+-----------+
1 row in set (0.062 sec)

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
