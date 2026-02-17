# k8s-mini-platform
## What this is:
* A Kubernetes mini-platform running a containerized FastAPI service on Minikube with rolling updates, autoscaling, and health checks.
## Architecture:
* Deployment (replicas)
* Service (ClusterIP)
* ConfigMap
* Probes
* HPA
## How to run:
## Demo Commands:
## Important Troubleshooting Commands:
* kubectl logs -n mini-platform deploy/mini-api --tail=50
* kubectl describe pod -n mini-platform <pod-name>
* kubectl get events -n mini-platform --sort-by=.metadata.creationTimestamp | Select-Object -Last 20
