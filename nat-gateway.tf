resource "aws_eip" "nat_gateway" {
  for_each = local.nat_gateways

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-${each.key}-nat"
  })

}

resource "aws_nat_gateway" "main" {
  for_each = local.nat_gateways

  allocation_id = aws_eip.nat_gateway[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-${each.key}-nat"
  })

}
