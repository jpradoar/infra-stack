
# Crossplane

### Create namespace
<pre>
kubectl create namespace crossplane-system
</pre>

### Install with helm
<pre>
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm install crossplane --namespace crossplane-system crossplane-stable/crossplane
helm list -n crossplane-system
kubectl get all -n crossplane-system
</pre>

### Crossplane cli
<pre>
curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh
</pre>

### Aws support vpc
<pre>
kubectl crossplane install configuration registry.upbound.io/xp/getting-started-with-aws-with-vpc:v1.8.0
</pre>

### Create config file and secret
<pre>
AWS_PROFILE=default && echo -e "[default]\naws_access_key_id = $(aws configure get aws_access_key_id --profile $AWS_PROFILE)\naws_secret_access_key = $(aws configure get aws_secret_access_key --profile $AWS_PROFILE)" > creds.conf

kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=./creds.conf
</pre>



### Deploy provider config
<pre>
kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/release-1.8/docs/snippets/configure/aws/providerconfig.yaml
</pre>



### Provisioning (demo)
<pre>
kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/release-1.8/docs/snippets/compose/claim-aws.yaml
kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/release-1.8/docs/snippets/compose/pod.yaml
</pre>
