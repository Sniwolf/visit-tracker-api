#!/usr/bin/env bash

set -euo pipefail

echo "=== Starting Minikube Cluster ==="

if ! command -v minikube &> /dev/null; then
    echo "Minikube is not installed. Please run setup-local-k8s-macos.sh first."
    exit 1
fi

if minikube status &>/dev/null; then
    echo "Minikube cluster already running."
else
    echo "Launching Minikube with Docker driver..."
    minikube start --driver=docker
fi

echo "Minikube cluster is up and running!"

echo "Setting kubectl context to Minikube..."
kubectl config use-context minikube

echo "Minikube status:"
minikube status

echo "Kubernetes cluster info:"
kubectl cluster-info

echo "To launch the Kubernetes dashboard, run:"
echo "  minikube dashboard"