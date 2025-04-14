# Tactical RMM Helm Chart

This Helm chart deploys [Tactical RMM](https://github.com/youruser/tacticalrmm.git) and its supporting services on Kubernetes.

## Components Deployed

- Tactical RMM Backend
- Tactical RMM Frontend
- Celery Worker
- PostgreSQL (with optional PV/PVC)
- Redis
- NATS
- MeshCentral
- Ingress with fixed hostnames

## Prerequisites

- Kubernetes cluster
- Helm 3+
- Ingress Controller (e.g., NGINX)
- Optional: Persistent volume support (for PostgreSQL)

## Installation

1. Clone the repo or extract the Helm chart directory:

```bash
git clone https://github.com/youruser/tacticalrmm.git
cd tacticalrmm/tacticalrmm-helm
