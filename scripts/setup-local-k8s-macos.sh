#!/usr/bin/env bash

set -euo pipefail

echo "=== Checking for Docker... ==="

if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker Desktop from:"
    echo "https://www.docker.com/products/docker-desktop/"
    exit 1
else
    if ! docker info &> /dev/null; then
        echo "Docker is installed but not running. Please start Docker Desktop."
        exit 1
    else
        echo "Docker is installed and running."
    fi
fi

echo "=== Detecting Architecture... ==="
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    ARCH_TYPE="arm64"
else
    ARCH_TYPE="amd64"
fi
echo "Architecture detected: $ARCH_TYPE"

echo "=== Checking for kubectl... ==="

if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."

    KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

    echo "Downloading kubectl version $KUBECTL_VERSION for architecture $ARCH_TYPE..."


    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/darwin/${ARCH_TYPE}/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    sudo chown root: /usr/local/bin/kubectl

    echo "kubectl ${KUBECTL_VERSION} installed successfully."
else
    echo "kubectl is already installed: version $(kubectl version --client=true --output=json | jq -r '.clientVersion.gitVersion')"
fi

echo "=== Checking for Minikube... ==="
if ! command -v minikube &> /dev/null; then
    if command -v brew &> /dev/null; then
        echo "Installing Minikube via Homebrew..."
        brew install minikube
    else
        echo "Homebrew not found. Installing Minikube via curl..."
        curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-${ARCH_TYPE}"
        chmod +x "minikube-darwin-${ARCH_TYPE}"
        sudo mv "minikube-darwin-${ARCH_TYPE}" /usr/local/bin/minikube
        sudo chown root: /usr/local/bin/minikube
    fi
else
    echo "Minikube is already installed: version $(minikube version --short)"
fi

echo "Local Kubernetes setup complete!"

echo "=== Checking for Helm... ==="
if ! command -v helm &> /dev/null; then
    if command -v brew &> /dev/null; then
        echo "Installing Helm via Homebrew..."
        brew install helm
    else
        echo "Homebrew not found. Please install Helm manually:"
        echo "https://helm.sh/docs/intro/install/"
    fi
else
    echo "Helm is already installed: version $(helm version --short)"
fi