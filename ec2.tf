resource "aws_key_pair" "aws_key" {
  key_name   = "aws-key"
  public_key = file(var.pub_ssh_key)
}

resource "template_file" "startup" {
  template = file(var.startup_script_path)
  vars = {
    SERVER_ADDRESSES = join(",", aws_instance.private_server.*.private_ip)
    USERNAME         = var.instance_username
    SSH_KEY_PATH     = format("%s/%s", var.destination_ssh_directory, var.private_key_name)
  }

  depends_on = [
    aws_instance.private_server,
    module.vpc
  ]
}

resource "aws_instance" "bastion_server" {
  ami           = data.aws_ami.Ubuntu.id
  instance_type = var.instance_type
  tags = {
    Name = "bastion server"
  }
  # VPC
  subnet_id = element(module.vpc.public_subnets, 0)
  # Security Group
  vpc_security_group_ids = [aws_security_group.bastion_server_sg.id]
  # the Public SSH key
  key_name = aws_key_pair.aws_key.id


  provisioner "file" {
    source      = var.source_ssh_directory
    destination = var.destination_ssh_directory
  }

  # script to ensure that the instance can ssh onto the private hosts and access the internet
  provisioner "file" {
    content     = template_file.startup.rendered
    destination = "/tmp/startup.sh"
  }

  # Executing the startup script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/startup.sh",
      "sudo /tmp/startup.sh"
    ]
  }

  # Setting up the ssh connection to run the script which checks to see if we can ssh onto the private hosts and access the internet
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.instance_username
    private_key = file(var.private_ssh_key)
  }

  depends_on = [
    aws_instance.private_server,
    template_file.startup
  ]
}

resource "aws_instance" "private_server" {
  count         = var.instance_count
  ami           = data.aws_ami.Ubuntu.id
  instance_type = var.instance_type
  tags = {
    Name = "private server"
  }

  # the Public SSH key
  key_name = aws_key_pair.aws_key.id
  // only allow access via bastion
  associate_public_ip_address = false

  # private subnet access
  subnet_id = element(module.vpc.private_subnets, count.index)
  # Security Group
  vpc_security_group_ids = [aws_security_group.private_server_sg.id]

  depends_on = [
    module.vpc
  ]
}
