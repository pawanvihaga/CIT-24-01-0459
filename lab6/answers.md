# Task 1.2 – Kubernetes Component Table

| Observed Pod | Component | Purpose |
|---------------|-----------|---------|
| kube-apiserver-minikube | API Server | Handles all Kubernetes API requests and communication. |
| etcd-minikube | etcd | Stores the cluster configuration and current state. |
| kube-scheduler-minikube | Scheduler | Assigns newly created Pods to worker nodes. |
| kube-controller-manager-minikube | Controller Manager | Ensures the cluster matches the desired state. |
| kube-proxy | Worker Node Component | Handles networking and load balancing between Pods and Services. |
| coredns | DNS Service | Provides DNS resolution inside the cluster. |
| storage-provisioner | Storage Provisioner | Dynamically creates Persistent Volumes for storage requests. |

**Component not shown as a Pod**

The **kubelet** does not appear as a Pod because it runs directly as a system service on every Kubernetes node. It communicates with the API server and ensures containers are running correctly.

---

# Checkpoint Q1

The **control plane** manages the Kubernetes cluster. It schedules Pods, stores cluster information, processes API requests, and keeps the cluster in its desired state.

A **worker node** runs the application workloads. It contains the kubelet, kube-proxy, and the container runtime responsible for executing containers.

---

# Checkpoint Q2

Yes, the Pod IP changed after deleting and recreating the Pod. Pods are **ephemeral**, meaning they are temporary objects. When a Pod is deleted, Kubernetes creates a completely new Pod with a new IP address.

---

# Checkpoint Q3

1. The Deployment required three frontend Pods.
2. One Pod was manually deleted.
3. Kubernetes detected that only two Pods were running.
4. The Deployment controller compared the actual state with the desired state.
5. A new Pod was automatically created.
6. The Deployment returned to three running Pods.

This demonstrates Kubernetes' **self-healing** capability.

---

# Checkpoint Q4

Each application tier is deployed independently. The frontend uses its own Deployment, while the database uses a StatefulSet. Therefore, the frontend can be scaled without affecting the database because communication occurs through Kubernetes Services.

---

# Checkpoint Q5

Using **port-forward** creates a temporary connection directly to a single Pod.

A **Service** provides a permanent network endpoint that automatically forwards traffic to healthy Pods. Since Pods are temporary and their IP addresses change, Services ensure applications remain accessible.

---

# Checkpoint Q6

Kubernetes performs rolling updates by gradually replacing Pods without causing downtime. It also stores rollout history and allows instant rollback if problems occur.

Docker Compose does not provide built-in rolling updates, automatic rollback, or Deployment controllers, making updates more manual and increasing the chance of downtime.

---

# Checkpoint Q7

The frontend and API are **stateless**, so they use Deployments. Their Pods can be replaced at any time without losing important information.

PostgreSQL stores persistent data, so it uses a StatefulSet with a PersistentVolumeClaim. This provides stable Pod names, ordered deployment, and persistent storage.

---

# Checkpoint Q8

No.

If PostgreSQL were deployed as a normal Deployment without a PersistentVolumeClaim, all database files stored inside the container would be lost when the Pod was deleted.

The PersistentVolumeClaim stores the data separately from the Pod, allowing it to survive Pod recreation.

---

# Checkpoint Q9

The broken Pod entered the **ImagePullBackOff** (or initially **ErrImagePull**) state.

This happened because Kubernetes could not download the specified container image due to an invalid image tag. Kubernetes repeatedly retries downloading the image, resulting in the ImagePullBackOff status.