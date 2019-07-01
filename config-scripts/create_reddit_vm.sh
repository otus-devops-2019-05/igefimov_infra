#!/bin/bash

ID_PROJECT=infra-244217
VM_NAME=reddit-full-vm
PORT=9292
TAGS=puma-server
IMAGE_FAMILY=reddit-full
DISK_SIZE=11GB
MACHINE_TYPE=f1-micro
ZONE=europe-west1-b

#Create instance from earlier prepared custom "baker" template
gcloud compute instances create $VM_NAME \
--boot-disk-size=$DISK_SIZE \
--image-family $IMAGE_FAMILY \
--machine-type=$MACHINE_TYPE \
--tags $TAGS \
--restart-on-failure \
--zone $ZONE

# Add firewall rule
gcloud compute --project=$ID_PROJECT firewall-rules create default-puma-server \
--direction=INGRESS --priority=1000 --network=default --action=ALLOW \
--rules=tcp:$PORT \
--source-ranges=0.0.0.0/0 \
--target-tags=$TAGS

