# テナントのAD名をlistで取得
data "oci_identity_availability_domains" "ADs" {
    compartment_id = "${var.tenancy_ocid}"
}

# vcn
resource "oci_core_virtual_network" "test" {
    cidr_block     = "${var.vcn_cidr}"
    compartment_id = "${var.compartment_ocid}"
    dns_label = "${var.vcn_dns_label}"
    display_name = "${var.vcn_display_name}"
}

# internet gw
resource "oci_core_internet_gateway" "test_igw" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.test.id}"
    display_name = "${var.igw_display_name}"
    enabled = true
}

# nat gw
resource "oci_core_nat_gateway" "test_ngw" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.test.id}"
    display_name = "${var.nat_gateway_display_name}"
}

# route table subnet01
resource "oci_core_route_table" "route_table_subnet01" {
    compartment_id = "${var.compartment_ocid}"
    route_rules {
        network_entity_id = "${oci_core_internet_gateway.test_igw.id}"
        destination = "0.0.0.0/0"
    }
    vcn_id = "${oci_core_virtual_network.test.id}"
    display_name = "${var.route_table_display_name01}"
}

# route table subnet02
resource "oci_core_route_table" "route_table-subnet02" {
    compartment_id = "${var.compartment_ocid}"
    route_rules {
        network_entity_id = "${oci_core_nat_gateway.test_ngw.id}"
        destination = "0.0.0.0/0"
    }
    vcn_id = "${oci_core_virtual_network.test.id}"
    display_name = "${var.route_table_display_name02}"
}

# security list subnet01
resource "oci_core_security_list" "sl_subnet01" {
    compartment_id = "${var.compartment_ocid}"
    egress_security_rules {
        destination = "${var.egress_destination_subnet01}"
        protocol = "${var.egress_protocol_subnet01}"
        stateless = false
        }
    ingress_security_rules {
        source = "${var.ingress_source_subnet01-01}"
        protocol = "${var.ingress_protocol_subnet01-01}"
        stateless = false
        description = "${var.ingress_description_subnet01-01}"
    }
    ingress_security_rules {
        source = "${var.ingress_source_subnet01-02}"
        protocol = "${var.ingress_protocol_subnet01-02}"
        stateless = false
        description = "${var.ingress_description_subnet01-02}"
        }
    vcn_id = "${oci_core_virtual_network.test.id}"
    display_name = "${var.sl_display_name_subnet01}"
}

# security list subnet02
resource "oci_core_security_list" "sl_subnet02" {
    compartment_id = "${var.compartment_ocid}"
    egress_security_rules {
        destination = "${var.egress_destination_subnet02}"
        protocol = "${var.egress_protocol_subnet02}"
        stateless = false
        }

    ingress_security_rules {
        source = "${var.ingress_source_subnet02-01}"
        protocol = "${var.ingress_protocol_subnet02-01}"
        stateless = false
        description = "${var.ingress_description_subnet02-01}"
        tcp_options {
            max = "${var.ingress_tcp_dest_port_max_subnet02-01}"
            min = "${var.ingress_tcp_dest_port_min_subnet02-01}"
        }
    }

    ingress_security_rules {
        source = "${var.ingress_source_subnet02-02}"
        protocol = "${var.ingress_protocol_subnet02-02}"
        stateless = false
        description = "${var.ingress_description_subnet02-02}"
        tcp_options {
            max = "${var.ingress_tcp_dest_port_max_subnet02-02}"
            min = "${var.ingress_tcp_dest_port_min_subnet02-02}"
        }
    }

# ICMP
    ingress_security_rules {
        protocol = 1
        source   = "0.0.0.0/0"
        stateless = false
        icmp_options {
        type = 3
        code = 4
        }
    }

    ingress_security_rules {
        protocol = 1
        source   = "${var.vcn_cidr}"
        stateless = false
        icmp_options {
        type = 3
        }
    }

# file system
    ingress_security_rules {
        protocol = "6"
        source   = "${var.vcn_cidr}"
        tcp_options {
        min = 2048
        max = 2050
        }
    }

    ingress_security_rules {
        protocol = "6"
        source   = "${var.vcn_cidr}"
        tcp_options {
        source_port_range {
            min = 2048
            max = 2050
        }
        }
    }

    ingress_security_rules {
        protocol = "6"
        source   = "${var.vcn_cidr}"

        tcp_options {
        min = 111
        max = 111
        }
    }
    vcn_id = "${oci_core_virtual_network.test.id}"
    display_name = "${var.sl_display_name_subnet02}"
}

# subnet01
resource "oci_core_subnet" "test_subnet01" {
    availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
    cidr_block = "${var.subnet01_cidr_block}"
    compartment_id = "${var.compartment_ocid}"
    security_list_ids = ["${oci_core_security_list.sl_subnet01.id}"]
    vcn_id = "${oci_core_virtual_network.test.id}"
    dns_label = "${var.subnet01_dns_label}"
    prohibit_public_ip_on_vnic = "${var.subnet01_prohibit_public_ip_on_vnic}"
    route_table_id = "${oci_core_route_table.route_table_subnet01.id}"
    display_name = "${var.subnet01_display_name}"
}

# subnet02
resource "oci_core_subnet" "test_subnet02" {
    availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
    cidr_block = "${var.subnet02_cidr_block}"
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.test.id}"
    dns_label = "${var.subnet02_dns_label}"
    security_list_ids = ["${oci_core_security_list.sl_subnet02.id}"] 
    prohibit_public_ip_on_vnic = "${var.subnet02_prohibit_public_ip_on_vnic}"
    route_table_id = "${oci_core_route_table.route_table-subnet02.id}"
    display_name = "${var.subnet02_display_name}"
}
