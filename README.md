# k8s-ho_setup_aws
Created to build kubernetes on AWS without EKS. But I recommend using EKS!! It is simply for my study :)

---
# Usage 
- install terraform in Mac OS
```bash
brew install terraform
```

  
- git clone k8s-ho_setup_aws
```bash
git clone https://github.com/k8s-ho/k8s-ho_setup_aws
cd k8s-ho_setup_aws
```

- setting terraform file & run terraform
```bash
provider.tf -> set your IAM information
terraform init
terraform plan
terraform apply -> yes
```

- rollback
```bash
terraform destroy -> yes
```
