# Visit Tracker API
![CI](https://github.com/Sniwolf/visit-tracker-api/actions/workflows/main.yml/badge.svg)

A simple FastAPI application that tracks visits, health, and uptime — designed to showcase containerization, CI/CD pipelines, and Kubernetes/Helm-based deployment.

---

## 📘 API Endpoints

| Method | Path     | Description                  |
|--------|----------|------------------------------|
| GET    | `/health` | Simple health check          |
| GET    | `/ready`  | Readiness check              |
| GET    | `/visits` | Returns current visit count  |
| GET    | `/info`   | Returns app metadata         |

Example response from `/info`:
```json
{
  "app_name": "Visit Tracker",
  "version": "1.0.0",
  "author": "Sni",
  "uptime": 243
}
```

## ⚙️ Local Dev Setup (FastAPI only)
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

## 🔁 CI/CD: GitHub Actions + Docker Hub
This project uses GitHub Actions for:
- FastAPI validation on push
- Health endpoint testing
- Docker image build and test
- Image push to DockerHub

### Run the latest version locally:
The latest Docker image is published to [DockerHub](https://hub.docker.com/r/sniwolf/visit-tracker-api)

You can run it locally with:
```bash
docker pull sniwolf/visit-tracker-api:latest
docker run -p 8000:8000 sniwolf/visit-tracker-api
```

### The CI workflow is defined in:
```text
.github/workflows/main.yaml
```

## Running Locally with Minikube

This project supports multiple deployment modes inside Minikube.

### 🔧 Prerequisites (macOS)
Run the setup script once to install required tools:
```bash
./scripts/setup-local-k8s-macos.sh
```

This installs:
- Docker (must be installed and running)
- kubectl (Kubernetes CLI)
- minikube (local Kubernetes cluster manager)
- helm (Kubernetes package manager)

#### Start your cluster:
```bash
./scripts/start-minikube-cluster.sh
```
You can also launch the Kubernetes dashboard with:
```bash
minikube dashboard
```

### 🔁 Autoscaling
This project supports Horizontal Pod Autoscaling (HPA) via the Helm chart.
- Autoscaler is enabled by default and scales between 1 and 3 replicas
- CPU utilization target: 70%
- Configurable in `values.yaml` and `values.local.yaml` under the `autoscaling` block.

To view the autoscaler:
```bash
kubectl get hpa
```
To disable autoscaling, set `autoscaling.enabled: false` in your values file.

### 📦 Resource Requests & Limits
The deployment supports setting CPU and memory resource requests and limits. 

By default the section is enabled in `values.yaml` and `values.local.yaml`. You can deactivate these by commenting out the resources section in the same files.

### 📄 Option 1: Raw Kubernetes YAML (Prebuilt Image)
1. Deploy:
```bash
kubectl apply -f k8s/prod-deployment.yaml
```

2. Access:
```bash
minikube service visit-tracker-service
```

3. Clean up:
```bash 
kubectl delete -f k8s/prod-deployment.yaml
minikube stop
```

### 📦 Option 2: Helm Deployment (Prebuilt Image)
1. Deploy:
```bash
helm upgrade --install visit-tracker-api ./helm
```
2. Access:
```bash
minikube service visit-tracker-api
```
3. Clean up:
```bash
helm uninstall visit-tracker-api
minikube stop
```

### 🛠 Option 3: Helm Deployment (Local Image)
This uses `values.local.yaml` with `imagePullPolicy:Never`.
1. Point Docker to Minikube:
```bash
eval $(minikube docker-env)
```
2. Build the image inside Minikube:
```bash
docker build -t visit-tracker-api:dev .
```

3. Deploy with Helm:
```bash
helm upgrade --install visit-tracker ./helm -f helm/values.local.yaml
```

4. Access:
```bash
minikube service visit-tracker
```

5. Clean up:
```bash
helm uninstall visit-tracker
minikube stop
eval $(minikube docker-env -u)
```

### 🐢 Alternate: Raw Kubernetes Deployment (Local Dev)
1. Point Docker to Minikube
```bash
eval $(minikube docker-env)
```
Verify:
```bash
docker info | grep 'Name'
# Should return: name: minikube
```

2. Build the image locally inside Minikube:
```bash
docker build -t visit-tracker-api: dev .
```

3. Apply the local deployment YAML:
```bash
kubectl apply -f k8s/local-deployment.yaml
```

4. Access the app:
```bash
minikube service visit-tracker-service
```

5. Clean up:
```bash
kubectl delete -f k8s/local-deployment.yaml
minikube stop
eval $(minikube docker-env -u)
```

## 🔎 Troubleshooting
Check pod logs:
```bash
kubectl get pods
kubectl logs <pod-name>
```

## Project Structure
```text
.
├── app/                       # FastAPI app code
│   ├── routes.py
│   ├── services/
│   ├── models/
│   └── core/
├── helm/                     # Helm chart and templates
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── values.local.yaml
│   └── templates/
├── k8s/                      # Raw Kubernetes manifests
│   ├── prod-deployment.yml
│   └── local-deployment.yml
├── .github/                  # GitHub Actions workflow
│   └── workflows/
├── scripts/                  # Helper setup scripts
│   ├── setup-local-k8s-macos.sh
│   └── start-minikube-cluster.sh
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── README.md
```

## 📝 Notes
- Readiness and liveness probes use:
  - /health (liveness)
  - /ready (readiness)
- Port 8000 is exposed on all deployment methods
- Helm installs use NodePort by default for Minikube compatibility
