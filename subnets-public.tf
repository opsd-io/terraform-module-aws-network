resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                              = aws_vpc.main.id
  availability_zone                   = each.value.availability_zone
  cidr_block                          = each.value.cidr_block
  map_public_ip_on_launch             = true
  private_dns_hostname_type_on_launch = each.value.hostname_type
  tags = merge(var.common_tags, each.value.extra_tags, {
    Name = "${var.vpc_name}-${each.key}"
  })
}

resource "aws_route_table" "public_group" {
  for_each = var.public_subnet_groups

  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, each.value.extra_tags, {
    Name = "${var.vpc_name}-${each.key}-rtb"
  })
}

resource "aws_route" "public_igw" {
  for_each = var.public_subnet_groups

  route_table_id         = aws_route_table.public_group[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  route_table_id = aws_route_table.public_group[each.value.group_name].id
  subnet_id      = aws_subnet.public[each.key].id
}
