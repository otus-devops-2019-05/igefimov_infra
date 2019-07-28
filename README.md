# igefimov_infra :czech_republic:

igefimov Infra repository
## Homework 1
* Integrated personal Slack channel #igor_efimov with Travis CI 
* Fixed python test
* Add PR template 

## Homework 2
* Signed up for a free GCP account
* Uploaded public ssh key to the platform 
* Spinned up 2 VM(one with public + internal IP and one with internal IP only) in the europe-west1-d zone:
```bash
bastion_IP = 35.210.33.211
someinternalhost_IP = 10.132.0.5

```

###### Independent task :bangbang:
Come up with one liner for  ssh connection to the someinternalhost through the bastion from my local machine.

**Solution 1:**
```bash 
ssh-add /Users/efimovi/Otus/DevOps_course/.ssh/gcp
ssh -t -A gcp@35.210.33.211 ssh 10.132.0.5
ssh -A -J gcp@35.210.33.211 gcp@10.132.0.5
```

**Solution 2:**
```bash 
ssh-add /Users/efimovi/Otus/DevOps_course/.ssh/gcp
ssh -A -J gcp@35.210.33.211 gcp@10.132.0.5
```
**Problems** :sweat_smile:
Sometimes ssh connection is hanging. Restart VM from GCP UI in order to fix it.

###### Extra task :star: :star: :star:
Come up with ssh alias in order to connect to the someinternalhost through the bastion from my local machine

**Solution**
```bash
tee -a ~/.ssh/config << END
Host bastion
  HostName 35.210.33.211
  User gcp
  IdentityFile ~/Otus/DevOps_course/.ssh/gcp

Host someinternalhost
  HostName 10.132.0.5
  user gcp
  ProxyJump bastion

END
```

* Added few Emoji
* Added .idea to the .gitignore file
* Allow http/https traffic for bastion VM
* Installed mongodb and pritunl(VPN server) on bastion VM using setupvpn.sh
```bash
cat <<EOF> setupvpn.sh
#!/bin/bash
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list
echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod
```

* Configured and Started VPN server on port 16290/udp
* Downloaded configuration file(cloud-bastion.ovpn) for VPN to local machine
* Installed TunnelBlick(OpenVPN client) and added configuration file from previous step
* Connected to someinternalhost using private IP thx to active VPN connection
    * credentials: test/6214157507237678334670591556762

**Problems** :sweat_smile:

Couldn't connect to VPN server: 
```bash
2019-06-20 11:32:44.201117 UDP link local: (not bound)
2019-06-20 11:32:44.201131 UDP link remote: [AF_INET]35.210.33.211:16290
```
**Solution**

Checked firewall rules and networking VM section.
Added 2 more networking tags: <VPN_hostname> <firewall_rule>
Overall there should be 4 networking tags: bastion, http-server, https-server, vpn-16290

###### Extra task :star: :star: :star:
Enable TLS encryption for VPN Server UI

**Solution**
* Register domain name igorefimov.ml and link it to bastion public IP address
* Update VPN Server setting with a new domain

<img src="images/vpn_server_domain_encrypted.png" width=700>

## Homework 3
* Using command "git mv" moved cloud-bastion.ovpn and setupvpn.sh to the VPN folder
* Created 3 bash scrips:
    * install_ruby.sh - installs Ruby
    * install_mongodb.sh - installs MongoDB
    * deploy.sh - deploys reddit-app application on the port 9292
 
```bash
testapp_IP = 35.205.198.5
testapp_port = 9292
```

###### Extra task :star: :star: :star:
* Create start up script, that will be running during the VM initialization
* Create firewall rule using gcloud command

**Solution**
I've created l  aunch_reddit-app.sh which:
* Prepares startup script using already existing 3 bash scripts(install_ruby, install_mongodb, deploy)
* Starts a new VM using gcloud command with attached startup script
* Creates new firewall rule for port 9292
* Removes startup script

## Homework 4
**Lesson 7: Модели управления инфраструктурой.**

I've created image files for packer.
First image has preinstalled dependencies as MongoDB and Ruby:
```bash
packer (packer-base) $ packer validate -var-file=variables.json ubuntu16.json
Template validated successfully.

packer build -var-file=variables.json ubuntu16.json
==> Builds finished. The artifacts of successful builds are:
--> googlecompute: A disk image was created: reddit-base-1562016331
```

Second image is "baked" and is based on previous image("source_image_family": "reddit-base"):
```bash
packer validate -var-file=variables.json immutable.json
Template validated successfully.


packer build -var-file=variables.json immutable.json
==> Builds finished. The artifacts of successful builds are:
--> googlecompute: A disk image was created: reddit-full-1562018315

```

Created config-scripts/create_reddit_vm.sh that creates VM from previously built image with puma server is already 
running and creates firewall rule for port 9292 

## Homework 5
**Lesson 8: Практика Infrastructure as a Code (IaC).**

Prerequisites:
* Make sure that "reddit-base" image is present
* Remove ssh key for gcp user from Compute Engine -> Metadata -> SSH-keys
* Install terraform v 0.11.7
* Add to .gitignore temporary/state terraform files


Created main.tf and defined **Provider** section- here we state that terraform can manage GCP resources via API calls

```bash
terraform init
Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "google" (2.0.0)...
Terraform has been successfully initialized!
You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary
```

Terraform provides wide list of resource to work with GCP: https://www.terraform.io/docs/providers/google/index.html
Resource used to start a VM: https://www.terraform.io/docs/providers/google/r/compute_instance.html


Let's create a new instance and firewall rule. See terraform/main.tf file in git repo
```bash
terraform plan
terraform apply -auto-approve

```
As a result of previous command is new file **terraform.tfstate** where terraform stores state of all created resources

```bash
terraform show
terraform show | grep nat_ip
```

Create a new file outputs.tf:

```hcl-terraform
output "app_external_ip" {
	value = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
}
```

Refresh the value:
```bash
$ terraform refresh
```
Now we can get external IP using: 
```bash
$ terraform output
app_external_ip = 35.187.115.196

```


Define new section **Provisioners**. Provisioners are executed during the resource creation/deletion and allow to 
execute commands on remote or local machine.

*Let's use provisioners to deploy last version of application*  

```hcl-terraform
  # Here we define Provisioners and how they connect to the VM(protocol, credentials)
  connection {
    type = "ssh"
    user = "gcp"
    agent = false
    private_key = "${file("/Users/efimovi/Otus/DevOps_course/.ssh/gcp")}"
  }

  provisioner "file" {
    source = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
```

Because Provisioners run only after creation/deletion of the resource, first we need to delete our VM.
Let's use command *taint* that will recreate specific resource after next *terraform apply* command:

```bash
$ terraform taint google_compute_instance.app
The resource google_compute_instance.app in the module root
has been marked as tainted!
```

```bash
terraform plan
terraform apply
```

Let's parametrize config files and describe variables in the variables.tf:
```hcl-terraform
variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
```

Values for the variables let's store in a separate file:
```bash
$ cat terraform.tfvars
project = "infra-244217"
public_key_path = "/Users/efimovi/Otus/DevOps_course/.ssh/gcp.pub"
disk_image = "reddit-base"
```

And use these variables in main.tf:
```hcl-terraform
provider "google" {
version = "2.0.0"
project = "${var.project}"
region = "${var.region}"
}
```


```bash
terraform destroy
terraform plan
terraofrm apply -auto-approve
```

###### Independent task :bangbang:
* Added more variables
* Because terraform.tfvars is not part of GIT repo(it has credentials and added to the .gitignore), we created 
terraform.tfvars.example 

###### Extra task :star:
* Added multiple ssh keys for different users to the project metadata.
* Added ssh key for appuser_web through the GCP UI. Noticed that each time we make changes in terraform 
configuration, ssh keys are being re-writted(key introduced through GCP UI is being erased).
* Add ssh keys for project only through the terraform
* Ssh keys for the instance only are deprecated
###### Extra task :star: :star:
* Created lb.tf where have described load balancer
* Created second instance(reddit-app2)
* Removed second instance
* Used parameter *count* in google_compute_instance to create multiple instances of current VM
* Stopped puma service on one instance and checked that service is still available from load balancer(because it is 
still running on the second instance)
* Added load balancer and VMs ips to the output file

## Homework 6
**Lesson 8 Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform.** 
* Imported firewall created in the GCP UI into the terraform infrastructure
* Created firewall resource
* Moved DB to a different VM images using Packer
* Upload new images to GCP using Packer
* Created app.tf db.tf and vpc.tf
* Moved tf file into the modules
* Created Stage and Prod envs and used previously created modules there
* Used storage-bucket service from registry

###### Extra task :star:
* Saved in S3 bucket our terraform.tfstate file

###### Extra task :star: :star:
* Updated Provisioner section
* Provisioners are started(app is deployed or not) based on variable *autodeploy*
* Application get IP of database from env variable DATABASE_URL

## Homework 8
**Lesson 8 Управление конфигурацией.**

**git branch: ansible-1**

* Installed ansibled
* Learned how to create inventory file in old-fashion and YAML style
* Tried manually modules: ping, command, shell, service, git
* Created first playbook

###### Extra task :star:
* Created dynamic inventory: developed own python script that obtains list of VMs deployed in project using gcloud 
command
* We can use this script as inventory: ansible all -i inventory-script.py -m  ping

## Homework 9
**Lesson 11 Продолжение знакомства с Ansible: templates, handlers, dynamic inventory, vault, tags.**

**git branch: ansible-2**

* Created One playbook with one play
* Created One playbook with multiple plays
* Created Few playbooks with multiple plays
* Used Ansible in the Provisioner section in Packer and baked again new VM images and uploaded them to GCP

###### Extra task :star:
I don't see any difference between this and last Homework with :star:
You can reference to my previous homework to see how I use dynamic inventory

## Homework 10
**Lesson 12 Принципы организации кода для управления конфигурацией.**

**git branch: ansible-3**

* Started using Roles(app, db)
* Started using community role for nginx
* Used ansible Vault for encruption of user credentials

###### Extra task :star:
* CLoned and setted up trytravis project
* Added my own script for TravisCI tests

#TODO still need to polish custom script and properly finish 2 :star: tasks



## Homework 11
**Локальная разработка Ansible ролей с Vagrant. Тестирование конфигурации.**

**git branch: ansible-4**

* Install VirtualBox - Vagrant here will create VMs
* Installed Vagrant - tool used for local development
* Describe our local infra using Vagrantfile. It will the same as we created in GCP using terraform
* Vagrant Provisioning: let's use Ansible roles db & app
* Vagrant automatically generates inventory file for Provisioning
* Parametrized role. Now it can be used by diff users. Introduced variable deploy_user
* Update Vagrant configuration for nginx role

**Testing Ansible roles**
* Use virtualenv to install all the testing tools
* Install Molecule to create VMs and check its configuration
* Install Testinfra to test roles


**Problems** :sweat_smile:
Run: packer build -force -var-file=packer/variables.json packer/db.json
Faced this issue: https://github.com/hashicorp/packer/issues/5065
Solution: add ANSIBLE_SSH_ARGS="-o IdentitiesOnly=yes" into the packer file(packer/db.json)

###### Extra task :star:
**Install own role**
0) Created a new repo with role and pushed it to github
1) Modify requirements file
2) ansible-galaxy install -r environments/stage/requirements.yml

**Start project**
1) cd terraform/stage && terraform apply --auto-approve && cd ../..
2) Get output from terraform & Change IP addresses in ansible/environments/stage/inventory
3) Change db_host value in ansible/environments/stage/group_vars/app
3) cd ansbile && ansible-galaxy install -r environments/stage/requirements.yml && cd ..
4) cd ansible && ansible-playbook playbooks/site.yml

**Release resources:**
cd terraform/stage && terraform destroy --auto-approve && cd ../..