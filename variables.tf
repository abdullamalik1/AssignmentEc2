variable "env" {
  type        = string
  description = "the environment that is currently being deployed, this should be overwritten by the tfvars"
}

variable "vpc_cidr" {
  description = "The CIDR for the vpc"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "A list of availability zones to use for this region"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "public_subnet_cidrs" {
  description = "A list of public subnet cidrs"
  type        = list(string)
  default     = ["10.0.16.0/20", "10.0.32.0/20", "10.0.48.0/20"]
}

variable "private_subnet_cidrs" {
  description = "A list of public subnet cidrs"
  type        = list(string)
  default     = ["10.0.64.0/20", "10.0.80.0/20", "10.0.96.0/20"]
}

variable "vpn_ipv4_cidr_blocks" {
  description = "allow access from the ipv4 vpn into the VPC"
  type        = list(string)
  default = [
    "24.46.35.244/32"
  ]
}

variable "vpn_ipv6_cidr_blocks" {
  description = "allow access from the ipv6 vpn into the VPC"
  type        = list(string)
  default     = []
}


variable "enable_dns_hostnames" {
  description = "boolean used to indicate whether or not to enable dns hostnames for new hosts"
  default     = true
}

variable "pub_ssh_key" {
  description = "the path to the public ssh key"
  default     = "./ssh_key/id_rsa.pub"
}

variable "private_ssh_key" {
  description = "the path to the private ssh key"
  default     = "./ssh_key/id_rsa"
}

variable "private_key_name" {
  description = "the name of the private key"
  default     = "id_rsa"
}


variable "instance_type" {
  description = "the instance type for the ec2 instances"
  default     = "t2.micro"
}

variable "instance_count" {
  default     = "2"
  description = "the number of private ec2 instances that should be running"
}

variable "instance_username" {
  description = "the username for the ec2 instance user, default for ubuntu is a user named ubuntu"
  default     = "ubuntu"
}

variable "destination_ssh_directory" {
  description = "the destination directory where the ssh files should be placed. When sshing to the private instance, these ssh credentials are used"
  default     = "~/jumpbox_ssh/"
}

variable "source_ssh_directory" {
  description = "the source directory where the ssh files are located. These are copied onto the different ec2 instances, enabling ssh connectivity."
  default     = "./ssh_key"
}

variable "startup_script_path" {
  description = "the startup script which is ran when provisioning the server"
  default     = "./scripts/startup.sh.tpl"
}
