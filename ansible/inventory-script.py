#!/usr/bin/python

import subprocess
import ast
import json
import argparse


# cmd = "gcloud compute instances list --format json"
# instance_list = subprocess.check_output(['bash','-c', cmd])
# print instance_list[2:-3]
# # instance_list = ast.literal_eval(instance_list)
# # print instance_list[0]









###########       Script reads instances deployed to the project and creates dynamic inventory for Ansible
# You can test it:
# ./inventory-script.py --list
# ansible (ansible-1) $ ansible all -i inventory-script.py -m ping
#


data = {
    "app": [
    ],
	  "db": [

	  ]
}

j = 0
cmd = "gcloud compute instances list | tail -n +2 | tr -s ' ' | cut -d ' ' -f1,5"
output = subprocess.check_output(['bash','-c', cmd]).split()
for i in output:
    if "app" in i:
        data["app"].append(output[j+1])
    if "db" in i:
        data["db"].append(output[j+1])
    j += 1

with open("inventory.json", "w") as write_file:
    json.dump(data, write_file)


parser = argparse.ArgumentParser()
parser.add_argument('--list', action = 'store_true')

args = parser.parse_args()

if args.list: print data
