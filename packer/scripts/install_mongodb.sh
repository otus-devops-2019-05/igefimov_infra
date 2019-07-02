#!/bin/bash

# Add keys and MongoDB repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

#Refresh package index and install required MongoDB package
apt update
apt install -y mongodb-org

#Start MongoDB
systemctl start mongod

#Enable it at the startup
systemctl enable mongod

