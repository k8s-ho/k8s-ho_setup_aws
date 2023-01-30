# instance
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
              sudo git clone https://github.com/k8s-ho/k8s-ho_setup
              sudo touch hellllllooo.txt
              EOF
}
