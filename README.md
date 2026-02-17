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
* Make sure you have Minikube and Docker Desktop both installed on your machine. The project can be done on a terminal or IDE, I chose to do it on VS code.
* Go to VS Code terminal and type: minikube start --driver=docker
* Once it is running, you can try 'kubectl get nodes', to see if kubectl works and gives you a list of nodes in your cluster.
* You can also do 'kubectl get all' to see all services.
* (Optional but recommended): Type 'minikube addons enable metrics-server' and then 'kubectl top nodes' to verify metrics-server is working. This important when we want Horizontal pod scaling to work.
## Demo Commands:
## Important Troubleshooting Commands:
* kubectl logs -n mini-platform deploy/mini-api --tail=50
* kubectl describe pod -n mini-platform <pod-name>
* kubectl get events -n mini-platform --sort-by=.metadata.creationTimestamp | Select-Object -Last 20
