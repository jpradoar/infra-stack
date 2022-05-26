#!/bin/bash

# Slack > Browse Apps > Custom Integrations > Incoming WebHooks > Webhook URL
slack_hook="https://hooks.slack.com/services/AAAAAAA/BBBBBBB/zzzzzzzzzzzzzzzzzzzzz"
pub_ip=$(curl -s ifconfig.me)
slack_channel="PPPPPPPP"

curl -sX POST -H 'Content-type: application/json' --data '{"text":"START TERRAFORM INSTALL EC2", "channel": "'$slack_channel'"}' $slack_hook
sudo apt update
sudo apt install docker.io docker-compose -y 
sudo usermod -aG docker $whoami
docker run --name nginx -p 80:80 -d nginx

sleep 3

INTERNAL_IP=$(curl -s 127.0.0.1 --write-out '%{http_code}' --output /dev/null)
PUB_IP=$(curl -s $pub_ip --write-out '%{http_code}' --output /dev/null)

if [[ "$INTERNAL_IP" -ne 200 ]] ; then
	# Check if docker start and send msg to slack channel
  	curl -sX POST -H 'Content-type: application/json' --data '{"text":"Nginx docker NOT START, please check", "channel": "'$slack_channel'"}' $slack_hook
else
	# Send msg to know docker is running from localhost
	curl -sX POST -H 'Content-type: application/json' --data '{"text":"Nginx docker start Ok", "channel": "'$slack_channel'"}' $slack_hook
	
	# Check if my service is accesible from outside (internet)
	if [[ "$PUB_IP" -ne 200 ]] ; then
		# If not accesible send msg to check
	  	curl -sX POST -H 'Content-type: application/json' --data '{"text":"Nginx docker IS NOT ACCESIBLE FROM INTERNET, please check", "channel": "'$slack_channel'"}' $slack_hook
	else
		# If is accesible Ok, send msg to finish all process :)
		curl -sX POST -H 'Content-type: application/json' --data '{"text":"Nginx docker IS ACCESIBLE FROM INTERNET :D ", "channel": "'$slack_channel'"}' $slack_hook
	fi
	# done :D
	exit 0
fi
