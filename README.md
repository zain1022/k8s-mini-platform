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
* (Optional but recommended): Type 'minikube addons enable metrics-server' and then 'kubectl top nodes' to verify metrics-server is working. This is important when we want Horizontal pod scaling to work.
* Make sure you have all the necessary files/code, including the .py file, yaml files, requirements.txt, and the dockerfile.
* Use minikube's docker daemon so image is available instantly (so minikube can actually see your image): '& minikube -p minikube docker-env --shell powershell | Invoke-Expression'
* And then build your image using the following commands:
  * docker build -t mini-api:1.0 .
  * docker images | Select-String mini-api
  * Note: Make sure that when you build the image your files are in the correct folders in order for the code to work properly.
  * You can check and make sure they are in the right place by looking at the directory, and also by doing 'Get-Content .\<file_name>'
* Afterwards, apply all the mainfests using 'kubectl apply -f' command.
## Demo Commands:
## Important Troubleshooting Commands:
* kubectl logs -n mini-platform deploy/mini-api --tail=50
* kubectl describe pod -n mini-platform <pod-name>
* kubectl get events -n mini-platform --sort-by=.metadata.creationTimestamp | Select-Object -Last 20
