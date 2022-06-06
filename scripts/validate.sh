#!/bin/bash
#
echo "Validate yaml files" 
find . -iname *.yaml -exec ls -l {} + |awk {'print "./polaris/cmd/polaris audit --color --format pretty --audit-path", $9'}|sh

echo -e "\n\n\n\n#-----------------------------------------------\n"

echo "Validate remote repo" 
git remote get-url origin --push|cut -d":" -f2|awk {'print "trivy repo github.com/"$1'}|sh

echo -e "\n\n\n\n#-----------------------------------------------\n"

echo "Validate docker images"
docker images |grep -v IMAGE |awk {'print "trivy image --security-checks  vuln,config,secret --no-progress --severity MEDIUM,HIGH,CRITICAL  ", $3'}|sh


echo -e "\n\n\n\n#-----------------------------------------------\n"

echo "Validate Terraform"
docker run --rm -it -v "$(pwd):/src" aquasec/tfsec /src

