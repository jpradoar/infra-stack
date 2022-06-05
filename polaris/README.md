# Polaris, validate best parctices on yaml files. 


### Download polaris
	mkdir -p cmd; cd cmd && wget https://github.com/FairwindsOps/polaris/releases/download/6.0.0/polaris_linux_amd64.tar.gz
	
### unzip and remove files 
	tar -xzf polaris_linux_amd64.tar.gz && rm -rf README.md LICENSE polaris_linux_amd64.tar.gz

### run simple test
	./polaris audit --color --format pretty --audit-path .../argocd/
