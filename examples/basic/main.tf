module "network" {
  source = "github.com/opsd-io/terraform-module-aws-network"

  vpc_name   = "test-vpc"
  cidr_block = "10.100.0.0/16"

  public_subnet_groups = {
    "public1" = {
      nat_gateway = true
      availability_zones = {
        "a" = { cidr_block = "10.100.1.0/24" }
        "b" = { cidr_block = "10.100.2.0/24" }
        "c" = { cidr_block = "10.100.3.0/24" }
      }
    }
  }

  private_subnet_groups = {
    "private-vms" = {
      nat_group_name = "public1"
      availability_zones = {
        "a" = { cidr_block = "10.100.101.0/24" }
        "b" = { cidr_block = "10.100.102.0/24" }
        "c" = { cidr_block = "10.100.103.0/24" }
      }
    }
    "private-svc" = {
      nat_group_name = "public1"
      availability_zones = {
        "a" = { cidr_block = "10.100.201.0/24" }
        "b" = { cidr_block = "10.100.202.0/24" }
        "c" = { cidr_block = "10.100.203.0/24" }
      }
    }
  }

}
