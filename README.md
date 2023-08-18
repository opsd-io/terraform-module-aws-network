<a href="https://www.opsd.io" target="_blank"><img alt="OPSd" src=".github/img/OPSD_logo.svg" width="180px"></a>

Meet **OPSd**. The unique and effortless way of managing cloud infrastructure.

# terraform-module-template

## Introduction

What does the module provide?

## Usage

```hcl
module "module_name" {
  source  = "github.com/opsd-io/module_name"
  version = ">= 0.1.0"

  # Variables
  variable_name     = foo
  variable_password = bar
}
```

**IMPORTANT**: Make sure not to pin to master because there may be breaking changes between releases.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpn_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |
| [aws_availability_zones.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_cidr_blocks"></a> [additional\_cidr\_blocks](#input\_additional\_cidr\_blocks) | The additional IPv4 CIDR blocks for the VPC. | `set(string)` | `[]` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The main IPv4 CIDR block for the VPC. | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A map of tags to assign to every resource in this module. | `map(string)` | `{}` | no |
| <a name="input_igw_name"></a> [igw\_name](#input\_igw\_name) | The 'Name' tag of Internet Gateway. | `string` | `null` | no |
| <a name="input_private_subnet_groups"></a> [private\_subnet\_groups](#input\_private\_subnet\_groups) | Private subnet groups definition map. See examples for details. | <pre>map(object({<br>    hostname_type  = optional(string, null) # Valid values: ip-name, resource-name.<br>    extra_tags     = optional(map(string), {})<br>    nat_group_name = optional(string, null) # name of public_subnet_group, ie. 'public1'<br>    nat_group_zone = optional(string, null) # zone suffix, ie. 'b'<br>    availability_zones = map(object({<br>      cidr_block     = string<br>      extra_tags     = optional(map(string), {})<br>      nat_group_name = optional(string, null) # name of public_subnet_group, ie. 'public1'<br>      nat_group_zone = optional(string, null) # zone suffix, ie. 'b'<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_public_subnet_groups"></a> [public\_subnet\_groups](#input\_public\_subnet\_groups) | Public subnet groups definition map. See examples for details. | <pre>map(object({<br>    hostname_type = optional(string, null) # Valid values: ip-name, resource-name.<br>    extra_tags    = optional(map(string), {})<br>    nat_gateway   = optional(bool, false)<br>    availability_zones = map(object({<br>      cidr_block  = string<br>      extra_tags  = optional(map(string), {})<br>      nat_gateway = optional(bool, null)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_vgw_name"></a> [vgw\_name](#input\_vgw\_name) | The 'Name' tag of VPN Gateway. | `string` | `null` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The 'Name' tag of VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | A map of AZ prefixes and their full names. |
| <a name="output_internet_gateway_arn"></a> [internet\_gateway\_arn](#output\_internet\_gateway\_arn) | The ARN of the Internet Gateway. |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The ID of the Internet Gateway. |
| <a name="output_private_subnet_groups"></a> [private\_subnet\_groups](#output\_private\_subnet\_groups) | Private subnet groups attributes (id, arn, etc.). |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Flattened version of private\_subnet\_groups. |
| <a name="output_public_subnet_groups"></a> [public\_subnet\_groups](#output\_public\_subnet\_groups) | Public subnet groups attributes (id, arn, etc.). |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Flattened version of public\_subnet\_groups. |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |
| <a name="output_vpn_gateway_arn"></a> [vpn\_gateway\_arn](#output\_vpn\_gateway\_arn) | The ARN of the VPN Gateway. |
| <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id) | The ID of the VPN Gateway. |
<!-- END_TF_DOCS -->

## Examples of usage

Do you want to see how the module works? See all the [usage examples](examples).

## Related modules

The list of related modules (if present).

## Contributing

If you are interested in contributing to the project, see see our [guide](https://github.com/opsd-io/contribution).

## Support

If you have a problem with the module or want to propose a new feature, you can report it via the project's (Github) issue tracker.

If you want to discuss something in person, you can join our community on [Slack](https://join.slack.com/t/opsd-community/signup).

## License

[Apache License 2.0](LICENSE)
