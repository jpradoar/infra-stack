
###  PARA PRODUCTIVIZAR UN SISTEMA O APP
	no correr como root 
	monitoreo		
	alta disponibilidad	(en lo posible, pero puede vivir en kubernetes)
	diseater recovery	(en lo posible)
	agnonstica 			(en lo posible)
	opensource			(en lo posible)
	named users



### Run jenkins job via API
curl -X POST -u 'user@domain.com:MY-PERSONAL-TOKEN' 'http://jenkins:8080/job/MY-JOB-NAME/buildWithParameters?token=MY-JOB-TOKEN&action=MY-ACTION-OPTION-IN-JOB'



### Polaris
polaris audit \
  --helm-chart ./deploy/chart \
  --helm-values ./deploy/chart/values.yml