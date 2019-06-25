#!/bin/bash

SCRIPT_NAME=startup-script.sh
PORT=9292
TAG=puma-server

#Startup script
echo "Preparing startup script"
rm $SCRIPT_NAME
echo "#!/bin/bash" > $SCRIPT_NAME
chmod +x $SCRIPT_NAME

echo -e "\n#Install ruby" >> $SCRIPT_NAME
sed -n '2,$p' install_ruby.sh >> $SCRIPT_NAME

echo -e "\n#Install MongoDB" >> $SCRIPT_NAME
sed -n '2,$p' install_mongodb.sh >> $SCRIPT_NAME

echo -e "\n#Deploy application" >> $SCRIPT_NAME
sed -n '2,$p' deploy.sh >> $SCRIPT_NAME

#Starting VM with startup script 
echo "Starting VM with startup script"
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags $TAG \
  --restart-on-failure \
  --metadata-from-file startup-script=$SCRIPT_NAME


#Create a firewall rule. Now we can access application through the web browser
echo "Create a firewall rule"
gcloud compute --project=infra-244217 firewall-rules create default-puma-server\
  --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:$PORT\
  --source-ranges=0.0.0.0/0 --target-tags=$TAG

#Remove Startup script
rm $SCRIPT_NAME
echo "Done"
