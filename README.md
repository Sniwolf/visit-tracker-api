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
└── scripts/
    ├── setup-local-k8s-macos.sh
    └── start-minikube-cluster.sh

</code></pre>

## API Endpoints
### ```GET /health```
Simple health check. Returns ```{"status": "ok}```

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