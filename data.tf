# Grab the latest Ubuntu AMI for the ec2 instances
data "aws_ami" "Ubuntu" {
  filter {
    name   = "is-public"
    values = ["true"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners      = ["099720109477"]
  most_recent = true
}
