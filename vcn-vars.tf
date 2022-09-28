# provider
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}

# vcn
variable "vcn_cidr" {}
variable "vcn_dns_label" {}
variable "vcn_display_name" {}

# internet gw
variable "igw_display_name" {}

# nat gw
variable "nat_gateway_display_name" {}

# route table subnet01
variable "route_table_display_name01" {}

# route table subnet02
variable "route_table_display_name02" {}

# security list subnet01
## egress
variable "egress_destination_subnet01" {}
variable "egress_protocol_subnet01" {}
## ingress
variable "ingress_source_subnet01-01" {}
variable "ingress_protocol_subnet01-01" {}
variable "ingress_description_subnet01-01" {}
variable "ingress_source_subnet01-02" {}
variable "ingress_protocol_subnet01-02" {}
variable "ingress_description_subnet01-02" {}
variable "sl_display_name_subnet01" {}

# security list subnet02
## egress
variable "egress_destination_subnet02" {}
variable "egress_protocol_subnet02" {}
## igress
variable "ingress_source_subnet02-01" {}
variable "ingress_protocol_subnet02-01" {}
variable "ingress_tcp_dest_port_max_subnet02-01" {}
variable "ingress_tcp_dest_port_min_subnet02-01" {}
variable "ingress_description_subnet02-01" {}
variable "ingress_source_subnet02-02" {}
variable "ingress_protocol_subnet02-02" {}
variable "ingress_tcp_dest_port_max_subnet02-02" {}
variable "ingress_tcp_dest_port_min_subnet02-02" {}
variable "ingress_description_subnet02-02" {}
variable "sl_display_name_subnet02" {}

# subnet01
variable "subnet01_cidr_block" {}
variable "subnet01_dns_label" {}
variable "subnet01_prohibit_public_ip_on_vnic" {}
variable "subnet01_display_name" {}

# subnet02
variable "subnet02_cidr_block" {}
variable "subnet02_dns_label" {}
variable "subnet02_prohibit_public_ip_on_vnic" {}
variable "subnet02_display_name" {}
