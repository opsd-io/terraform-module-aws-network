terraform {
  required_version = ">= 1.3.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  availability_zones = {
    for name in data.aws_availability_zones.current.names
    : trimprefix(trimprefix(name, data.aws_region.current.name), "-") => name
  }

  public_subnet_groups = {
    for group_name, grp in var.public_subnet_groups : group_name => {
      for zone_suffix, az in grp.availability_zones : zone_suffix => {
        subnet_name       = "${group_name}-${zone_suffix}"
        group_name        = group_name
        zone_suffix       = zone_suffix
        cidr_block        = az.cidr_block
        availability_zone = lookup(local.availability_zones, zone_suffix, zone_suffix)
        hostname_type     = grp.hostname_type
        nat_gateway       = coalesce(az.nat_gateway, grp.nat_gateway)
        extra_tags        = merge(grp.extra_tags, az.extra_tags)
      }
    }
  }

  private_subnet_groups = {
    for group_name, grp in var.private_subnet_groups : group_name => {
      for zone_suffix, az in grp.availability_zones : zone_suffix => {
        subnet_name       = "${group_name}-${zone_suffix}"
        group_name        = group_name
        zone_suffix       = zone_suffix
        cidr_block        = az.cidr_block
        availability_zone = lookup(local.availability_zones, zone_suffix, zone_suffix)
        hostname_type     = grp.hostname_type
        nat_group_name    = coalesce(az.nat_group_name, grp.nat_group_name)
        nat_group_zone    = coalesce(az.nat_group_zone, grp.nat_group_zone, zone_suffix)
        extra_tags        = merge(grp.extra_tags, az.extra_tags)
      }
    }
  }

  public_subnets = merge([
    for grp in local.public_subnet_groups : {
      for net in grp : net.subnet_name => net
  }]...)

  private_subnets = merge([
    for grp in local.private_subnet_groups : {
      for net in grp : net.subnet_name => net
  }]...)

  nat_gateways = {
    for key, net in local.public_subnets : key => net if net.nat_gateway
  }

  # Filtered public subnets groups: just those with NAT gateway.
  nat_subnet_names = {
    for group_name, grp in local.public_subnet_groups : group_name => {
      for zone_suffix, net in grp : zone_suffix => net.subnet_name
      if net.nat_gateway
    }
  }

  # if we have NAT-GW in choosen zone: use it; else use first one in group.
  nat_gateway_map = {
    for key, snet in local.private_subnets : key => try(
      local.nat_subnet_names[snet.nat_group_name][snet.nat_group_zone],
      element(values(local.nat_subnet_names[snet.nat_group_name]), 0),
      null
    )
  }

}

data "aws_region" "current" {
  # no arguments
}

data "aws_availability_zones" "current" {
  all_availability_zones = true
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.common_tags, {
    Name = var.vpc_name
  })
}

resource "aws_vpc_ipv4_cidr_block_association" "main" {
  for_each   = var.additional_cidr_blocks
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, {
    Name = coalesce(var.igw_name, "${var.vpc_name}-igw")
  })
}

resource "aws_vpn_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, {
    Name = coalesce(var.vgw_name, "${var.vpc_name}-vgw")
  })
}
