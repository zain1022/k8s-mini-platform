minikube start --driver=docker
minikube addons enable metrics-server

kubectl apply -f manifests/

kubectl get all -n mini-platform
