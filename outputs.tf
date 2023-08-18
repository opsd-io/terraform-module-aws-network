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
