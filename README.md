# Visit Tracker API
   ![CI](https://github.com/Sniwolf/visit-tracker-api/actions/workflows/main.yml/badge.svg)

   A simple FastAPI application that tracks visits, health, and uptime, designed for DevOps deployment and containerization.

## Local Dev Setup
### 1. Clone Repo
   ```bash
   git clone https://github.com/Sniwolf/visit-tracker-api.git
   ```
### 2. Create and activate a virtual environment
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate 
   ```
### 3. Install Dependencies
   `pip install -r requirements.txt`

   Key packages used:
   - fastapi
   - uvicorn
   - pydantic
   - pydantic-settings

### 4. Run the app
   `uvicorn app.main:app --reload`

## 🧩 Project Structure
<pre><code> 
.
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── routes.py
│   ├── models/
│   │   └── responses.py
│   ├── services/
│   │   ├── visits.py
│   │   └── info.py
│   └── core/
│       └── config.py
├── .dockerignore
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── README.md
├── .pre-commit-config.yaml
├── .github/
│   └── workflows/
│       └── main.yml
├── scripts/
│   ├── setup-local-k8s-macos.sh
│   └── start-minikube-cluster.sh
└── k8s/
    ├── prod-deployment.yml
    └── local-deployment.yml

</code></pre>

## API Endpoints
### ```GET /health```
Simple health check. Returns ```{"status": "ok"}```

### ```GET /ready```
Simple readiness check. Returns ```{"status": "ready"}```

### ```GET /visits```
Returns visit count. Returns ```{"count": 3}```

### ```GET /info```
Returns metadata about the app, like uptime, version, etc.
```json
{
  "app_name": "Visit Tracker",
  "version": "1.0.0",
  "author": "Sni",
  "uptime": 243
}
```

## 🐳 Run with Docker

### Build the Docker image:
```bash
docker build -t visit-tracker-api .
```

### Run the container:
```bash
docker run -p 8000:8000 visit-tracker-api
```

Then visit:
http://localhost:8000/health

## 🐳 Run with Docker Compose
```bash
docker compose up --build
```

then visit:
http://localhost:8000/health

### To stop the app:
```bash
docker compose down
```

## CI/CD
This project uses GitHub Actions for continuous integration and delivery:
- Validates the FastAPI app on push to `main`
- Builds and pushes a Docker image to Dockerhub if tests pass

### Docker Image
The latest Docker image is published to [DockerHub](https://hub.docker.com/r/sniwolf/visit-tracker-api)

You can run it locally with:
```bash
docker pull sniwolf/visit-tracker-api:latest
docker run -p 8000:8000 sniwolf/visit-tracker-api
```

### `.github/workflows/` explination
```md
The GitHub Actions workflow is defined in `.github/workflows/main.yml` and includes

- Python app validation
- Health check endpoint testing
- Docker image build and test
- Image publishing to Dockerhub
```
## Running a Local Kubernetes Cluster

This project supports running locally on kubernetes via Minikube.

### Prerequisites (macOS only):
Run the setup script once to install required tools:
```bash
./scripts/setup-local-k8s-macos.sh
```

This installs and configures:
- Docker (must already be installed and running)
- `kubectl` (Kubernetes CLI)
- `minikube` (Kubernetes local cluster manager)

⚠️ This script is idempotent — you can rerun it safely.

### Start the Kubernetes Cluster
Use the helper script to start the local cluster and set up your context:
```bash
./scripts/start-minikube-cluster.sh
```
This script:
- Starts Minikube (if not already running)
- Switches kubectl context to Minikube
- Displays the current cluster status
- Prints connection details

You can also launch the Kubernetes dashboard with:
```bash
minikube dashboard
```

## Stopping or Deleteing the Cluster
To stop the Minikube cluster (without deleting it):
```bash
minikube stop
```

To delete the cluster entirely:
```bash
minikube delete
```
This is useful for resetting the local environment if something goes wrong.

## Running Locally with Minikube
### Option 1: Using Prebuilt Image from Dockerhub (simple)
#### 1. After starting your Minikube cluster, deploy the application using the following:
```bash
kubectl apply -f k8s/prod-deployment.yml
```
#### 2. Once the app is deployed you can use the following to access it:
```bash
minikube service visit-tracker-service
```
Then use one of the following endpoints to interact with the app:
- ```/health```
- ```/ready```
- ```/visits```
- ```/info```

#### 3. Clean Up
When you're done, you can clean up your Kubernetes environment with:
```bash
kubectl delete -f k8s/prod-deployment.yml
```

You can then use the following command to stop Minikube
```bash
minikube stop
```

#### Troubleshooting
View the logs with
```bash
kubectl get pods
kubectl logs <your-pod-name>
```

### Option 2: Build and Run Your Own Image (For Local Development)
This works because the image is built inside Minikube and imagePullPolicy: Never is set in local-deployment.yml, so Kubernetes uses your local image.
#### 1. Point Docker to Minikube
```bash
eval $(minikube docker-env)
```
You can verify you docker is in Minikube's Docker context
```bash
docker info | grep 'Name'
```
It should say something like `name: minikube`

#### 2. Build the image locally:
```bash
docker build -t visit-tracker-api:dev .
```
#### 3. Deploy using the local development file:
```bash
kubectl apply -f k8s/local-deployment.yml
```
#### 4. Once the app is deployed you can use the following to access it:
```bash
minikube service visit-tracker-service
```
Then use one of the following endpoints to interact with the app:
- ```/health```
- ```/ready```
- ```/visits```
- ```/info```

#### 5. When you're done, you can clean up your Kubernetes environment with:
```bash
kubectl delete -f k8s/local-deployment.yml
```

#### 6. Stop Minikube
```bash
minikube stop
```

#### 7. Reset your shell after dev:
```bash
eval $(minikube docker-env -u)
```

#### Troubleshooting
View the logs with
```bash
kubectl get pods
kubectl logs <your-pod-name>
```

## 🚀 Helm Chart Deployment

This project now supports deployment via a custom [Helm](https://helm.sh/) chart.

### Requirements

- [Minikube](https://minikube.sigs.k8s.io/docs/) (for local Kubernetes testing)
- [Helm](https://helm.sh/) 3.x
- Docker (used by Minikube cluster to build and run the image locally)

### Setup Instructions

1. **Start Minikube** (if not already running):
   ```bash
   bash scripts/start-minikube-cluster.sh
   ```
2. **Deploy with Helm** 
   ```bash
   helm install visit-tracker-api ./helm
   ```
   ***Or upgrade***
   ```bash
   helm upgrade --install visit-tracker-api ./helm
   ```
3. ***Access the Service***
   ```bash
   minikube service visit-tracker-api
   ```
   Then use one of the following endpoints to interact with the app:
   - ```/health```
   - ```/ready```
   - ```/visits```
   - ```/info```

4. ***🧹Cleanup***
   To remove the deployed resources from your Minikube cluster:
   ```bash
   helm uninstall visit-tracker-api
   ```
   To stop your Minikube Cluster:
   ```bash
   minikube stop
   ```
   To delete your Minikube cluster:
   ```bash
   minikube delete
   ```

Notes
 - Probes are configured with custom paths (/health for liveness, /ready for readiness) on port 8000.

 - You can find or modify these settings in values.yaml.

 - Default service type is NodePort for local access in Minikube.