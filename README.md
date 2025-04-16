# Tactical RMM


[![.github/workflows/ci-tests.yml](https://github.com/mors126/do-fl-test-rmm/actions/workflows/ci-tests.yml/badge.svg)](https://github.com/mors126/do-fl-test-rmm/actions/workflows/ci-tests.yml)

[![Publish Tactical Docker Images](https://github.com/mors126/do-fl-test-rmm/actions/workflows/docker-build-push.yml/badge.svg)](https://github.com/mors126/do-fl-test-rmm/actions/workflows/docker-build-push.yml)

[![Deploy Helm Chart to Minikube](https://github.com/mors126/do-fl-test-rmm/actions/workflows/deploy-to-minikube.yml/badge.svg)](https://github.com/mors126/do-fl-test-rmm/actions/workflows/deploy-to-minikube.yml)


Tactical RMM is a remote monitoring & management tool, built with Django and Vue.\
It uses an [agent](https://github.com/amidaware/rmmagent) written in golang and integrates with [MeshCentral](https://github.com/Ylianst/MeshCentral)

# [LIVE DEMO](https://demo.tacticalrmm.com/)

Demo database resets every hour. A lot of features are disabled for obvious reasons due to the nature of this app.

### [Discord Chat](https://discord.gg/upGTkWp)

### [Documentation](https://docs.tacticalrmm.com)

## Features

- Teamviewer-like remote desktop control
- Real-time remote shell
- Remote file browser (download and upload files)
- Remote command and script execution (batch, powershell, python, nushell and deno scripts)
- Event log viewer
- Services management
- Windows patch management
- Automated checks with email/SMS/Webhook alerting (cpu, disk, memory, services, scripts, event logs)
- Automated task runner (run scripts on a schedule)
- Remote software installation via chocolatey
- Software and hardware inventory

## Windows agent versions supported

- Windows 7, 8.1, 10, 11, Server 2008R2, 2012R2, 2016, 2019, 2022

## Linux agent versions supported

- Any distro with systemd which includes but is not limited to: Debian (10, 11), Ubuntu x86_64 (18.04, 20.04, 22.04), Synology 7, centos, freepbx and more!

## Mac agent versions supported

- 64 bit Intel and Apple Silicon (M-Series)

## Sponsorship Features

- Mac and Linux Agents
- Windows [Code Signed](https://docs.tacticalrmm.com/code_signing/) Agents
- Fully Customizable [Reporting](https://docs.tacticalrmm.com/ee/reporting/reporting_overview/) Module
- [Single Sign-On](https://docs.tacticalrmm.com/ee/sso/sso/) (SSO)

## Installation / Backup / Restore / Usage

### Refer to the [documentation](https://docs.tacticalrmm.com)

---

## Tactical RMM Helm Chart

This Helm chart deploys the full **Tactical RMM** stack into a Kubernetes cluster. It includes all core services and dependencies required for a functional environment, designed for local development with Minikube or other K8s clusters.

## Included Services

The chart deploys the following services:

- `backend`: Django-based backend API
- `frontend`: Vue-based web interface
- `meshcentral`: Remote control agent manager
- `postgres`: PostgreSQL database
- `redis`: In-memory cache
- `nats`: Lightweight messaging broker
- `mongodb`: Document DB for MeshCentral
- `nginx`: Ingress controller for routing traffic

---

## Component Interaction Table

| **Component** | **Type**    | **Depends On**                       | **Ports**      | **Description**                                                                |
| ------------- | ----------- | ------------------------------------ | -------------- | ------------------------------------------------------------------------------ |
| `backend`     | Deployment  | `postgres`, `redis`, `nats`          | `8000`         | Django-based backend API. Communicates with DB, Redis, and NATS.               |
| `frontend`    | Deployment  | `backend`                            | `8080`         | Vue.js frontend. Communicates with backend via API.                            |
| `meshcentral` | Deployment  | `mongodb`, `backend`                 | `4443`, `8080` | Provides remote control functionality. Requires MongoDB and backend for token. |
| `postgres`    | StatefulSet | Persistent Volume (PVC)              | `5432`         | PostgreSQL database for Tactical RMM.                                          |
| `redis`       | Deployment  | —                                    | `6379`         | Caching layer and session store.                                               |
| `nats`        | Deployment  | —                                    | `4222`         | Messaging system used for internal events.                                     |
| `mongodb`     | StatefulSet | Persistent Volume (PVC)              | `27017`        | Document-based DB for MeshCentral.                                             |
| `nginx`       | Deployment  | `frontend`, `backend`, `meshcentral` | `4443`, `8080` | Ingress controller for routing external traffic.                               |

---

## Configuration

- Configuration is split per service in `values.yaml`.
- Secrets (DB passwords, Django key, etc.) are **not stored** in `values.yaml`; use Kubernetes Secrets.
- You can override environment-specific values using files under `environments/dev/values.yaml`, `environments/prod/values.yaml`, etc.

---

## Deployment with GitHub Actions (Minikube)

The project includes a GitHub Actions workflow to:

- Set up Minikube
- Install Helm
- Deploy the chart using a GitHub-hosted runner

Secrets like database credentials must be added to your GitHub repository as `Actions secrets`.

---

## Health & Scaling

- Components include `liveness` and `readiness` probes.
- Resource requests/limits are defined for each container.
- HPA (Horizontal Pod Autoscaling) is available for scaling services based on CPU.

---

## TLS & Security

> ⚠️ TLS is not configured by default. Certificates and Ingress TLS setup should be handled separately once domain/DNS are ready.

---

## Directory Structure
```bash
tactical-helm/
  ├── charts/
  ├── templates/
  ├── values.yaml
  └── environments/
    └── dev/
      └── values.yaml
      └── secrets.yaml.template
```
---
## Testing Locally

### Prerequisites

- Kubernetes cluster
- Helm 3+
- Ingress Controller (e.g., NGINX)
- Optional: Persistent volume support (for PostgreSQL)

### Minimal hardware requirements for Minikube

- CPU: 2
- RAM: 4GB
- Disk: 20GB

### Installation

1. Clone the repo or extract the Helm chart directory:

```bash
git clone https://github.com/mors126/do-fl-test-rmm.git
cd tactical/tactical-helm
```

### Testing Locally

To test this chart on Minikube manually:

Secrets should be defined manually in values.yaml using the records below, replacing `YOUR_VALUE` with the right ones:
```bash
secrets:
  djangoSecretKey: YOUR_VALUE
  postgresUser: YOUR_VALUE
  postgresPassword: YOUR_VALUE
  postgresDb: YOUR_VALUE

mongodb:
  auth:
    rootPassword: YOUR_VALUE
    username: YOUR_VALUE
    password: YOUR_VALUE
    database: YOUR_VALUE
```
Run the command below to deploy:
```bash
helm upgrade --install tactical ./tactical-helm \
  --namespace tactical --create-namespace \
  --values ./tactical-helm/values.yaml \
  --values ./tactical-helm/environments/dev/values.yaml
```

### Check What Ingress Controller You’re Using
Minikube usually doesn't have an Ingress controller enabled by default. If you’re using NGINX Ingress, enable it with:

```bash
minikube addons enable ingress
```
### Get the Minikube IP
```bash
minikube ip
```
Let’s say it returns: 192.168.49.2

### Update /etc/hosts
Edit your local machine’s /etc/hosts file (with sudo if needed):

```bash
sudo nano /etc/hosts
```
Add entries like:

```bash
192.168.49.2  api.tactical.local
192.168.49.2  frontend.tactical.local
192.168.49.2  mesh.tactical.local
```

### Check Your Ingress Resources
Run:
```bash
kubectl get ingress

NAME	HOSTS	ADDRESS	PORTS	AGE
tacticalrmm-api	api.tactical.local	192.168.49.2	8080	...
tacticalrmm-ui	frontend.tactical.local	192.168.49.2	8080	...
meshcentral	mesh.tactical.local	192.168.49.2	8080	...
```

### Open in Browser
Now you can access:
http://api.tactical.local
http://frontend.tactical.local
http://mesh.tactical.local

If you’re using TLS (HTTPS), make sure your ingress has a valid certificate (via cert-manager or self-signed).
