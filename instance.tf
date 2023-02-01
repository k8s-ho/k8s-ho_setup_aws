# instance - master
resource "aws_instance" "master" {
  ami = "ami-051d287d02a19035f" # ubuntu 20.04 64bit
  subnet_id   = aws_subnet.k8s_subnet.id
  instance_type = "t2.medium"
  key_name = aws_key_pair.k8s_ho_admin.key_name
  root_block_device {
    volume_size = 30
  }
  user_data = <<-EOF
              #!/bin/bash
              git clone https://github.com/k8s-ho/k8s-ho_setup_aws
              cd /k8s-ho_setup_aws/k8s_setup
              chmod +x k8s_master_setup.sh k8s_pkg_env.sh
              sudo ./k8s_pkg_env.sh "master-k8sHo" && sudo ./k8s_master_setup.sh && echo "[Enter] sudo su" > finish_setup.txt
              EOF
  tags = {
    Name = "master-k8sHo"
  }
}

# instance - worker1
resource "aws_instance" "worker-1" {
 ami = "ami-051d287d02a19035f" # ubuntu 20.04 64bit
  subnet_id   = aws_subnet.k8s_subnet.id
  instance_type = "t2.medium"
  key_name = aws_key_pair.k8s_ho_admin.key_name
  root_block_device {
    volume_size = 30
  }
  user_data = <<-EOF
              #!/bin/bash
              git clone https://github.com/k8s-ho/k8s-ho_setup_aws
              cd /k8s-ho_setup_aws/k8s_setup
              chmod +x k8s_worker_setup.sh k8s_pkg_env.sh
              sudo ./k8s_pkg_env.sh "worker-1-k8sHo" && echo "[+] setup is complete" > finish_setup.txt
              EOF
  tags = {
    Name = "worker-1-k8sHo"
  }
}

# instance - worker2
resource "aws_instance" "worker-2" {
 ami = "ami-051d287d02a19035f" # ubuntu 20.04 64bit
  subnet_id   = aws_subnet.k8s_subnet.id
  instance_type = "t2.medium"
  key_name = aws_key_pair.k8s_ho_admin.key_name
  root_block_device {
    volume_size = 30
  }
  user_data = <<-EOF
              #!/bin/bash
              git clone https://github.com/k8s-ho/k8s-ho_setup_aws
              cd /k8s-ho_setup_aws/k8s_setup
              chmod +x k8s_worker_setup.sh k8s_pkg_env.sh
              sudo ./k8s_pkg_env.sh "worker-2-k8sHo" && echo "[+] setup is complete" > finish_setup.txt
              EOF
  tags = {
    Name = "worker-2-k8sHo"
  }
}

# instance - worker3
resource "aws_instance" "worker-3" {
 ami = "ami-051d287d02a19035f" # ubuntu 20.04 64bit
  subnet_id   = aws_subnet.k8s_subnet.id
  instance_type = "t2.medium"
  key_name = aws_key_pair.k8s_ho_admin.key_name
  root_block_device {
    volume_size = 30
  }
  user_data = <<-EOF
              #!/bin/bash
              git clone https://github.com/k8s-ho/k8s-ho_setup_aws
              cd /k8s-ho_setup_aws/k8s_setup
              chmod +x k8s_worker_setup.sh k8s_pkg_env.sh
              sudo ./k8s_pkg_env.sh "worker-3-k8sHo" && echo "[+] setup is complete" >finish_setup.txt
              EOF
  tags = {
    Name = "worker-3-k8sHo"
  }
}
