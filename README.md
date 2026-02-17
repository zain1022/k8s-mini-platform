# k8s-mini-platform
step-by-step Minikube build plan for Project 2 (Kubernetes Mini-Platform)

TROUBLESHOOTING:
* kubectl logs -n mini-platform deploy/mini-api --tail=50
* kubectl describe pod -n mini-platform <pod-name>
* kubectl get events -n mini-platform --sort-by=.metadata.creationTimestamp | Select-Object -Last 20
