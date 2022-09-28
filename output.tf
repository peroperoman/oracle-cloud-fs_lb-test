output "lb_private_ip" {
    value = ["${oci_load_balancer.web-lb.ip_address_details}"]
}
data "oci_core_private_ips" mount_target_ip {
    subnet_id = "${oci_core_subnet.test_subnet02.id}"

    filter {
        name   = "id"
        values = ["${oci_file_storage_mount_target.test_mount_target.private_ip_ids.0}"]
    }
}
output "mount_target_ip" {
    value = "${lookup(data.oci_core_private_ips.mount_target_ip.private_ips[0], "ip_address")}"
}

output "bastion_instance_ip" {
    value = "${oci_core_instance.test-bastion.*.private_ip[0]}"
}

output "web-instance_ip-1" {
    value = "${oci_core_instance.test-web.*.private_ip[0]}"
}

output "web-instance_ip-2" {
    value = "${oci_core_instance.test-web.*.private_ip[1]}"
}
