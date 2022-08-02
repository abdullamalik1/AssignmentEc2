module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "sample-app"
  cidr = var.vpc_cidr

  azs            = var.availability_zones
  public_subnets = var.public_subnet_cidrs
  create_igw     = true

  enable_nat_gateway     = true
  one_nat_gateway_per_az = false
  # nat gateways are billed based on time running up, for now, create a single nat gateway
  single_nat_gateway = true

  private_subnets      = var.private_subnet_cidrs
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      "Env" = terraform.workspace,
      "Name" : "sample_app"
    }
  )
}
