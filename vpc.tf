resource "aws_vpc" "k8s_vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "k8s-ho-vpc"
  }
}

resource "aws_subnet" "k8s_subnet" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "192.168.0.0/16"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-ho-subnet"
  }
}

resource "aws_network_interface" "k8s_eth0" {
  subnet_id   = aws_subnet.k8s_subnet.id
  private_ips = ["192.168.0.100"]
  attachment {
    instance     = aws_instance.master.id
    device_index = 1
  }
  tags = {
    Name = "k8s-ho-interface"
  }
}

resource "aws_internet_gateway" "k8s-gw" {
  vpc_id = aws_vpc.k8s_vpc.id
  tags = {
    Name = "k8s-ho-gateway"
  }
}

# modify default route table
resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.k8s_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s-gw.id
  }
  tags = {
    Name = "k8s-ho-route"
  }
}
