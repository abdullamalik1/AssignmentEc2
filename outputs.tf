output "outputs" {
  value = {
    bastion_host  = aws_instance.bastion_server.public_ip
    private_hosts = aws_instance.private_server.*.private_ip
  }
}
