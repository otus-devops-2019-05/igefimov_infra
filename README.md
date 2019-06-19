# igefimov_infra
igefimov Infra repository
## Homework 1
* Integrated personal Slack channel #igor_efimov with Travis CI 
* Fixed python test
* Add PR template 

## Homework 2
* Signed up for a free GCP account
* Uploaded public ssh key to the platform 
* Spinned up 2 VM in the europe-west1-d zone:
    * bastion with public IP address(35.210.33.211)
    * someinternalhost with internal-only IP address(10.132.0.5)

###### Independent task
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

###### Extra task :star:
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
