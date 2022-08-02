# Terraform

Terraform is used to automate the infrastructure for the desired project.

## Goal
The goal of the project is to create the necessary networking infrastructure which will contain an ec2 instance in a private subnet. The goal is
to be able to ssh onto this host, while also ensuring that the host can access the internet.

Components Needed:
1. VPC with a private subnet
2. Nat Gateway
3. Two EC2 Instances (1 in the public subnet, 1 in the private subnet)
4. SSH Key Pair

## Explanation
By placing a resource in a private subnet, it is unable to be reached outside the VPC that is created, meaning that we cannot access this resource from our local machines.
Instead, an ssh bastion/jumpbox, needs to be setup. A Jumpbox is essentially a server which is on a Public Subnet, and accessible to the outside world. The initial step is to
first connect to the bastion, afterwards a user can connect to the resources in the private subnets (depending on the security groups, etc).
SSH keys must be generated, afterwhich should be associated with the ssh bastion and the instances in the private subnet, otherwise this will not work.

A jumpbox solves the requirement of enabling ssh access. In order for the ec2 instance in the private subnet to connect to the internet, a NAT gateway is necessary. A NAT gateway
is essentially a gateway which allows resources within Private Subnets to connect outside the VPC that they are placed in.

## Steps to Apply Infrastructure
1. Export `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`
2. Create the desired s3 bucket, e.g: `sample-app-bucket-terraform-state`, this needs to be unique across all aws accounts.
3. Update the vpn ip address to include your ip address
```terraform
variable "vpn_ipv4_cidr_blocks" {
  description = "allow access from the ipv4 vpn into the VPC"
  type        = list(string)
  default     = [
  	"your_ip_address/32"
  ]
}
```
3. Generate an ssh key pair within the `ssh_key` directory
4. Setup terraform environment
```bash
terraform workspace new dev
terraform workspace select dev
terraform init
```
5. Apply terraform
```
terraform plan -var-file=./tfvars/dev.tfvars
terraform apply -var-file=./tfvars/dev.tfvars
```

# How to SSH onto the private instances (after applying)
1. SSH onto the bastion
`ssh -i ./ssh_key/id_rsa ubuntu@<BASTION_IP_ADDRESS_FROM_OUTPUT>`
2. From the jumpbox ssh onto the private instance
`ssh -i ~/jumpbox_ssh/id_rsa ubuntu@<IP_ADDRESS_OF_PRIVATE_INSTANCE_FROM_OUTPUT>`


# Destroying environment
`terraform destroy -var-file=./tfvars/dev.tfvars`
