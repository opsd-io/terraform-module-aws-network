locals {
  # Those locals are output helpers - these values are used twice, but in different format.
  output_public_subnet_groups = {
    for group_name, grp in local.public_subnet_groups : group_name => {
      for zone_suffix, net in grp : zone_suffix => {
        subnet_name       = net.subnet_name
        group_name        = net.group_name
        zone_suffix       = net.zone_suffix
        id                = aws_subnet.public[net.subnet_name].id
        arn               = aws_subnet.public[net.subnet_name].arn
        cidr_block        = aws_subnet.public[net.subnet_name].cidr_block
        availability_zone = aws_subnet.public[net.subnet_name].availability_zone
        route_table_id    = aws_route_table.public_group[net.group_name].id
      }
    }
  }
  output_private_subnet_groups = {
    for group_name, grp in local.private_subnet_groups : group_name => {
      for zone_suffix, net in grp : zone_suffix => {
        subnet_name       = net.subnet_name
        group_name        = net.group_name
        zone_suffix       = net.zone_suffix
        id                = aws_subnet.private[net.subnet_name].id
        arn               = aws_subnet.private[net.subnet_name].arn
        cidr_block        = aws_subnet.private[net.subnet_name].cidr_block
        availability_zone = aws_subnet.private[net.subnet_name].availability_zone
        route_table_id    = aws_route_table.private[net.subnet_name].id
      }
    }
  }
}

output "availability_zones" {
  description = "A map of AZ prefixes and their full names."
  value       = local.availability_zones
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}
output "vpc_arn" {
  description = "The ARN of the VPC."
  value       = aws_vpc.main.arn
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.main.id
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway."
  value       = aws_internet_gateway.main.arn
}

output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway."
  value       = aws_vpn_gateway.main.id
}

output "vpn_gateway_arn" {
  description = "The ARN of the VPN Gateway."
  value       = aws_vpn_gateway.main.arn
}

output "public_subnet_groups" {
  description = "Public subnet groups attributes (id, arn, etc.)."
  value       = local.output_public_subnet_groups
}

output "private_subnet_groups" {
  description = "Private subnet groups attributes (id, arn, etc.)."
  value       = local.output_private_subnet_groups
}

output "public_subnets" {
  description = "Flattened version of public_subnet_groups."
  value = merge([
    for grp in local.output_public_subnet_groups : {
      for net in grp : net.subnet_name => net
  }]...)
}

output "private_subnets" {
  description = "Flattened version of private_subnet_groups."
  value = merge([
    for grp in local.output_private_subnet_groups : {
      for net in grp : net.subnet_name => net
  }]...)
}
