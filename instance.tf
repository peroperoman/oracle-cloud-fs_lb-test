resource "oci_core_instance" "test-bastion" {
    count = "${var.bastion_num}"
    availability_domain = "${oci_core_subnet.test_subnet01.availability_domain}"
    compartment_id = "${var.compartment_ocid}"
    shape = "${var.instance_shape}"
    display_name = "${var.bastion_display_name}"
    create_vnic_details {
        subnet_id = "${oci_core_subnet.test_subnet01.id}"
    }
    source_details {
        source_id = "${var.CentOS7[var.region]}"
        source_type = "image"
    }
    metadata = {
        ssh_authorized_keys = "${var.ssh_public_key}"
    }
}

resource "oci_core_instance" "test-Web" {
    count = "${var.web_num}"
    availability_domain = "${oci_core_subnet.test_subnet02.availability_domain}"
    compartment_id = "${var.compartment_ocid}"
    shape = "${var.instance_shape}"
    display_name = "${var.web_display_name}"
    create_vnic_details {
        subnet_id = "${oci_core_subnet.test_subnet02.id}"
        assign_public_ip = false
    }
    source_details {
        source_id = "${var.CentOS7[var.region]}"
        source_type = "image"
    }
    metadata = {
        ssh_authorized_keys = "${var.ssh_public_key}"
    }
}
