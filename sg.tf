resource "aws_security_group" "bastion_server_sg" {
  description = "security group allowing access to the bastion host"
  name        = "bastion server security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow from vpn endpoints"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = concat(var.vpn_ipv4_cidr_blocks)
    ipv6_cidr_blocks = var.vpn_ipv6_cidr_blocks
  }

  ingress {
    description      = "Allow all from within security group"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }

  egress {
    description      = "Allow all out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    {
      "Env"  = terraform.workspace,
      "Name" = "Bastion Security Group"
    }
  )
}

resource "aws_security_group" "private_server_sg" {
  description = "private server security group access"
  name        = "private server security group access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow all from within security group"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }

  ingress {
    description     = "Allow ssh access from the bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_server_sg.id]
  }


  egress {
    description      = "Allow all out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Env"  = terraform.workspace,
    "Name" = "Private Server Security Group"
  }
}
