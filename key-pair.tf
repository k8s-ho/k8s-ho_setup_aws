# key pair
resource "aws_key_pair" "k8s_ho_admin" {
  key_name = "k8s_ho"
  public_key = file("~/.ssh/k8s-ho.pub")
}
