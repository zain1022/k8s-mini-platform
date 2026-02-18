# k8s-mini-platform
## What this is:
* A Kubernetes mini-platform running a containerized FastAPI service on Minikube with rolling updates, autoscaling, and health checks.
## Prerequisites
* Windows + PowerShell
* Docker Desktop
* Minikube
* kubectl
* (Optional) VS Code
## Architecture:
* Deployment (replicas)
* Service (ClusterIP)
* ConfigMap
* Probes
* HPA
## How to run:
* Make sure you have Minikube and Docker Desktop both installed on your machine. The project can be done on a terminal or IDE, I chose to do it on VS code.
* Go to VS Code terminal and type: ```powershell minikube start --driver=docker```
* Once it is running, you can try ```powershell kubectl get nodes```, to see if kubectl works and gives you a list of nodes in your cluster.
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
* You can do 'kubectl get all -n mini-platform' to make sure everything is running and 'kubectl get pods -n mini-platform' to see the pods in the mini-platform namespace.
* Next we need to test our service by doing 'kubectl port-forward -n mini-platform svc/mini-api-svc 8080:80' this will establish our connection and we can check if it works by using curl or going to these links in our browser:
  * http://localhost:8080/health
    * In /health you should see ENV and MESSAGE coming from your ConfigMap.
  * http://localhost:8080/items
* Additionally, we can confirm ConfigMap injection using the following commands:
  * kubectl get configmap -n mini-platform
  * kubectl describe configmap -n mini-platform api-config
  * Exec into a pod and print env vars:
    * kubectl get pods -n mini-platform
    * kubectl exec -n mini-platform -it <pod-name> -- sh
    * Inside pod:
      * echo $ENV
      * echo $MESSAGE
      * exit
* To do a rolling update, we update/change our app (ex. update /items list or message format) then we build new image:
  * & minikube -p minikube docker-env --shell powershell | Invoke-Expression
  * docker build -t mini-api:2.0 .
* Then update deployment image:
  * kubectl set image -n mini-platform deployment/mini-api api=mini-api:2.0
  * kubectl rollout status -n mini-platform deployment/mini-api
  * kubectl get pods -n mini-platform
  * Confirm it's updated by refreshing 'http://localhost:8080/items', we should see the new changes there.
* We can also do a rollback:
  * kubectl rollout undo -n mini-platform deployment/mini-api
  * kubectl rollout status -n mini-platform deployment/mini-api
  * When you refresh page/items should be back to how they were before the update.
* Lastly, we can also do an autoscaling (HPA) demo:
* First we need to confirm metrics work ->
  * kubectl top nodes
  * kubectl top pods -n mini-platform
  * kubectl get hpa -n mini-platform
* Then we need to generate load to force the autoscale:
  * kubectl run -n mini-platform loadgen --rm -it --image=busybox -- sh
  * Inside: while true; do wget -q -O- http://mini-api-svc/health > /dev/null; done
* In another terminal you can watch the scaling:
  * kubectl get hpa -n mini-platform -w
  * kubectl get deploy -n mini-platform -w
* You can stop load with Ctrl+C in the loadgen terminal.
* When you generate load you should see CPU utilization change and more replicas created, once you stop the load it should terminate the other ones and scale down back to it's original utilization.
## Here is an overall breakdown of Demo Commands used including some already mentioned in the 'how to run' section:
* This section shows how to build, deploy, update, scale, and debug the service on Minikube.
### Start Minikube + Prereqs:
```powershell
minikube start --driver=docker
minikube addons enable metrics-server

kubectl get nodes
kubectl top nodes
```
### Point Docker to Minikube’s Docker (IMPORTANT on Windows)
```powershell
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
```
### Build the Docker image
```powershell
docker build -t mini-api:1.0 .
docker images mini-api
```
Rebuild for update (force clean build): 
```powershell
docker build --no-cache -t mini-api:2.0 .
```
### Deploy to Kubernetes
```powershell
kubectl apply -f manifests/
# Can also apply each manifest individually
```
Check status:
 ```powershell
  kubectl get all -n mini-platform
  kubectl get pods -n mini-platform
 ```
Watch pods:
 ```powershell
  kubectl get pods -n mini-platform -w
 ```
### Access the service (port-forward)
```powershell
kubectl port-forward -n mini-platform svc/mini-api-svc 8080:80
```
### Rolling update (deploy new version)
```powershell
# Build new image:
docker build --no-cache -t mini-api:2.0 .
```
Update deployment:
```powershell
kubectl set image -n mini-platform deployment/mini-api api=mini-api:2.0
kubectl rollout status -n mini-platform deployment/mini-api
kubectl get pods -n mini-platform
```
### Rollback (undo deployment)
```powershell
kubectl rollout undo -n mini-platform deployment/mini-api
kubectl rollout status -n mini-platform deployment/mini-api
```
### Autoscaling (HPA) demo – generate load
Check HPA + metrics:
```powershell
kubectl get hpa -n mini-platform
kubectl top pods -n mini-platform
```
Start load generator:
```powershell
kubectl run -n mini-platform loadgen --rm -it --image=busybox -- sh
```
Inside the pod:
```powershell
while true; do wget -q -O- http://mini-api-svc/health > /dev/null; done
```
Watch scaling (new terminal):
```powershell
kubectl get hpa -n mini-platform -w
kubectl get deploy -n mini-platform -w
```
* Stop load -> Ctrl+C in the busybox terminal
### Debug / Important Troubleshooting Commands (very important for interviews)
```powershell
kubectl logs -n mini-platform deploy/mini-api --tail=50
```
```powershell
kubectl logs -n mini-platform <pod-name> --previous
```
```powershell
kubectl describe pod -n mini-platform <pod-name>
```
```powershell
kubectl get events -n mini-platform --sort-by=.metadata.creationTimestamp | Select-Object -Last 20
```
Exec into a pod:
```powershell
kubectl exec -n mini-platform -it <pod-name> -- sh
```
Check env vars inside pod:
```powershell
echo $ENV
echo $MESSAGE
```
### Service & endpoints checks
```powershell
kubectl get svc -n mini-platform
kubectl get endpoints -n mini-platform mini-api-svc
```
### Scale manually (optional cleanup)
```powershell
kubectl scale deployment -n mini-platform mini-api --replicas=2
```
#### Other commands:
```powershell
kubectl describe deploy -n mini-platform mini-api
```
### Convenience Scripts
* scripts/start.ps1 – starts Minikube and deploys the app
* scripts/deploy.ps1 – rebuilds the image and performs a rolling update
* scripts/portforward.ps1 – exposes the service locally
