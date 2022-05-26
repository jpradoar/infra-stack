
# Crossplane


kubectl create namespace crossplane-system

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane --namespace crossplane-system crossplane-stable/crossplane

helm list -n crossplane-system

kubectl get all -n crossplane-system


curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh


kubectl crossplane install configuration registry.upbound.io/xp/getting-started-with-aws-with-vpc:v1.8.0

AWS_PROFILE=default && echo -e "[default]\naws_access_key_id = $(aws configure get aws_access_key_id --profile $AWS_PROFILE)\naws_secret_access_key = $(aws configure get aws_secret_access_key --profile $AWS_PROFILE)" > creds.conf


kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=./creds.conf


kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/release-1.8/docs/snippets/configure/aws/providerconfig.yaml




### Provisioning (demo)

kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/release-1.8/docs/snippets/compose/claim-aws.yaml

kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/release-1.8/docs/snippets/compose/pod.yaml

