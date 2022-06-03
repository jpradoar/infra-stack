# Jenkins 


### Add jenkins helm repo
<pre>
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm show values jenkins/jenkins > jenkins-k8s.yaml
</pre>

### Create namespace
<pre>
kubectl create ns jenkins
</pre>

### Deploy jenkins
<pre>
helm -n jenkins install jenkins jenkins/jenkins -f jenkins-k8s.yaml
</pre>

### check if pod is running (its take a few minutes)
<pre>
kubectl -n jenkins get pod,svc
</pre>

### Access to Jenkins
<pre>
kubectl exec -n jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
kubectl -n jenkins port-forward svc/jenkins 8080:8080
</pre>
