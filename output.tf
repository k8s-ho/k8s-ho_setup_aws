output "master-k8sHo_public_ip" {
    value = aws_instance.master.public_ip
}
output "master-k8sHo_private_ip" {
    value = aws_instance.master.private_ip
}

output "worker-1-k8sHo_public_ip" {
    value = aws_instance.worker-1.public_ip
}
output "worker-1-k8sHo_private_ip" {
    value = aws_instance.worker-1.private_ip
}

output "worker-2-k8sHo_public_ip" {
    value = aws_instance.worker-2.public_ip
}
output "worker-2-k8sHo_private_ip" {
    value = aws_instance.worker-2.private_ip
}

output "worker-3-k8sHo_public_ip" {
    value = aws_instance.worker-3.public_ip
}
output "worker-3-k8sHo_private_ip" {
    value = aws_instance.worker-3.private_ip
}
