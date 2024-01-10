# k8s-ho_setup_aws
Created to build kubernetes on AWS without EKS. But I recommend using EKS!! It is simply for my study :)

---
### Cluster information (Ubuntu server 20.04)
- master:1 / worker:3
- kubeadm version 1.25.0 
- kubectl version 1.25.0
- kubelet version 1.25.0

---
# Usage 

### 1. Install terraform in Mac OS
```bash
brew install terraform
```
      
<br/>      
       
### 2. git clone k8s-ho_setup_aws
```bash
git clone https://github.com/k8s-ho/k8s-ho_setup_aws
cd k8s-ho_setup_aws
```
  
<br/>      

  
### 3. Setting terraform file & Run terraform
```bash
provider.tf -> set your IAM information
terraform init
terraform plan
terraform apply --auto-approve
```
=> When terraform execution is completed, it shows the connection ip and private ip.   
=> Remember that the ip of the master node is used below.
  
<br/>
  
---
### 💡Connection using SSH
```bash
ssh -i [key file path] ubuntu@[public ip]
```
---
  
<br/>      
  
### 4. You just have to wait while it is being created.  
- Please wait for about 5 minutes (up to 10 minutes??)
```bash
ls /k8s-ho_setup_aws/k8s_setup/
```
=> It will operate in the background and nothing will be visible, and when setup is complete, a finish_setup.txt file will be created in the above path.
  
<br/>      
  
### 5. Join worker nodes to kubernetes (to be automated...)
```bash
cd /k8s-ho_setup_aws/k8s_setup/
./k8s_worker_setup.sh [master private ip]
``` 
=> Connect to the worker node and execute the file in the above path     
=> When executing the command, the IP of the master node must be given as an argument !!!
  
<br/>        


### 6. Now connect to the master. The account uses root.
```bash
ssh -i [key file path] ubuntu@[master private ip]
k get node
```   

<br/>        
  
### ⏱️ Rollback
```bash
terraform destroy --auto-approve
```
