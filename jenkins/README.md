# Jenkins 


### Add jenkins helm repo
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm show values jenkins/jenkins > jenkins-k8s.yaml

### Create namespace 
kubectl create ns jenkins

### Deploy jenkins 
helm -n jenkins install jenkins jenkins/jenkins -f jenkins-k8s.yaml

### check if pod is running (its take a few minutes)
kubectl -n jenkins get pod,svc

### Access to Jenkins
kubectl exec -n jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
kubectl -n jenkins port-forward svc/jenkins 8080:8080

