# Point Docker to Minikube
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Build new image
docker build --no-cache -t mini-api:2.0 .

# Update deployment
kubectl set image -n mini-platform deployment/mini-api api=mini-api:2.0

# Watch rollout
kubectl rollout status -n mini-platform deployment/mini-api
