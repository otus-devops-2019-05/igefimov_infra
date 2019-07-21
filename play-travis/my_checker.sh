#!/usr/bin/env bash

echo '[INSTALLATION SECTION]'
echo '[PACKER] Installing packer'
wget -O /tmp/packer.zip https://releases.hashicorp.com/packer/1.3.4/packer_1.3.4_linux_amd64.zip
sudo unzip -o -d  /usr/local/bin/ /tmp/packer.zip

echo '[TERRAFORM] Installing terraform'
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip
sudo unzip -o -d  /usr/local/bin/ /tmp/terraform.zip

echo '[TFLINT] Installing tflint'
wget -O /tmp/tflint.zip https://github.com/wata727/tflint/releases/download/v0.7.4/tflint_linux_amd64.zip
sudo unzip -o -d  /usr/local/bin/ /tmp/tflint.zip

echo '[ANSIBLE-LINT] Intalling ansible-lint ==============='
pip install ansible-lint --user


echo '[VALIDATION SECTION]'
echo '[PACKER] Validate app.json'
packer validate -var-file=packer/variables.json.example packer/app.json
echo '[PACKER] Validate db.json'
packer validate -var-file=packer/variables.json.example packer/db.json

cd terraform/stage
echo "[TERRAFORM] Get"
terraform get
echo "[TERRAFORM] Init"
terraform init
echo "[TERRAFORM] Validate"
terraform validate
echo "[TERRAFORM] Tflint"
tflint --ignore-module SweetOps/storage-bucket
cd ../..



echo '[ANSIBLE] Validate site.yml ==============='
cd ansible
ansible-lint playbooks/site.yml --exclude=roles/jdauphant.nginx
cd ..
