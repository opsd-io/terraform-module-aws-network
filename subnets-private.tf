resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id                              = aws_vpc.main.id
  availability_zone                   = each.value.availability_zone
  cidr_block                          = each.value.cidr_block
  map_public_ip_on_launch             = false
  private_dns_hostname_type_on_launch = each.value.hostname_type

  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = false

  tags = merge(var.common_tags, each.value.extra_tags, {
    Name = "${var.vpc_name}-${each.key}"
  })
}

resource "aws_route_table" "private" {
  for_each = local.private_subnets

  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, each.value.extra_tags, {
    Name = "${var.vpc_name}-${each.key}-rtb"
  })
}

resource "aws_route" "private_nat" {
  for_each = local.private_subnets

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[local.nat_gateway_map[each.key]].id
}

resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  route_table_id = aws_route_table.private[each.key].id
  subnet_id      = aws_subnet.private[each.key].id
}
