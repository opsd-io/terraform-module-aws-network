variable "common_tags" {
  description = "A map of tags to assign to every resource in this module."
  type        = map(string)
  default     = {}
}

variable "vpc_name" {
  description = "The 'Name' tag of VPC."
  type        = string
}

variable "cidr_block" {
  description = "The main IPv4 CIDR block for the VPC."
  type        = string
}

variable "additional_cidr_blocks" {
  description = "The additional IPv4 CIDR blocks for the VPC."
  type        = set(string)
  default     = []
}

variable "public_subnet_groups" {
  description = "Public subnet groups definition map. See examples for details."
  type = map(object({
    hostname_type = optional(string, null) # Valid values: ip-name, resource-name.
    extra_tags    = optional(map(string), {})
    nat_gateway   = optional(bool, false)
    availability_zones = map(object({
      cidr_block  = string
      extra_tags  = optional(map(string), {})
      nat_gateway = optional(bool, null)
    }))
  }))
  default = {}
}

variable "private_subnet_groups" {
  description = "Private subnet groups definition map. See examples for details."
  type = map(object({
    hostname_type  = optional(string, null) # Valid values: ip-name, resource-name.
    extra_tags     = optional(map(string), {})
    nat_group_name = optional(string, null) # name of public_subnet_group, ie. 'public1'
    nat_group_zone = optional(string, null) # zone suffix, ie. 'b'
    availability_zones = map(object({
      cidr_block     = string
      extra_tags     = optional(map(string), {})
      nat_group_name = optional(string, null) # name of public_subnet_group, ie. 'public1'
      nat_group_zone = optional(string, null) # zone suffix, ie. 'b'
    }))
  }))
  default = {}
}
