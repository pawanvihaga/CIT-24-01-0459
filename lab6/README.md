# Lab 06 – Kubernetes Fundamentals with Minikube
---

# Objective

The objective of this lab was to gain practical experience with Kubernetes using Minikube. The lab covered creating Pods, Deployments, Services, StatefulSets, scaling applications, rolling updates, persistent storage, troubleshooting, and Kubernetes networking.

---

# Technologies Used

- Docker Desktop
- Kubernetes
- Minikube
- kubectl
- YAML
- Nginx
- HTTPBin
- Redis
- PostgreSQL
- BusyBox

---

# Project Structure

```
lab6/
│
├── k8s/
│   ├── pod-frontend.yaml
│   ├── deployment-frontend.yaml
│   ├── service-frontend.yaml
│   ├── api-deployment.yaml
│   ├── api-service.yaml
│   ├── cache-deployment.yaml
│   ├── cache-service.yaml
│   ├── postgres-statefulset.yaml
│   ├── postgres-service.yaml
│   └── broken-pod.yaml
│
├── screenshots/
│
├── answers.md
│
└── README.md
```

---

# Application Architecture

```
                +-------------------+
                |     Frontend      |
                |   Nginx Deployment|
                +---------+---------+
                          |
                          |
                +---------v---------+
                |     API Service   |
                | HTTPBin Deployment|
                +---------+---------+
                          |
            +-------------+-------------+
            |                           |
            |                           |
+-----------v----------+      +---------v----------+
|   Redis Deployment   |      | PostgreSQL         |
|   Cache Service      |      | StatefulSet + PVC  |
+----------------------+      +--------------------+
```

---

# Kubernetes Resources Created

- 1 Pod
- 3 Deployments
- 4 Services
- 1 StatefulSet
- 1 PersistentVolumeClaim

---

# Features Demonstrated

- Pod creation
- Deployments
- Self-healing
- Scaling replicas
- NodePort Service
- ClusterIP Service
- Headless Service
- Rolling updates
- Rollbacks
- StatefulSets
- PersistentVolumeClaims
- Internal DNS
- Metrics Server
- Troubleshooting ImagePullBackOff

---

# Commands Used

## Start Minikube

```bash
minikube start --driver=docker
```

## Check Cluster

```bash
kubectl get nodes
kubectl get pods
kubectl get all
```

## Deploy Resources

```bash
kubectl apply -f k8s/
```

## Scale Deployment

```bash
kubectl scale deployment frontend --replicas=5
```

## Rolling Update

```bash
kubectl set image deployment/frontend frontend=nginx:1.27-alpine
```

## Rollback

```bash
kubectl rollout undo deployment/frontend
```

## View Services

```bash
kubectl get services
```

## Access Frontend

```bash
minikube service frontend --url
```

## Delete Resources

```bash
kubectl delete -f k8s/
```

## Stop Minikube

```bash
minikube stop
```

---

# Screenshots Included

- Task 1.1
- Task 2.1
- Task 3.1
- Task 4.1
- Task 5.1
- Task 6.1
- Task 7.1
- Task 7.2
- Task 8.1
- Task 9.1
- Task 10.1

---

# Learning Outcomes

Through this lab, I learned how Kubernetes manages containerized applications using Pods, Deployments, Services, and StatefulSets. I also learned how Kubernetes provides self-healing, scaling, rolling updates, persistent storage, and service discovery while simplifying container orchestration compared to Docker Compose.