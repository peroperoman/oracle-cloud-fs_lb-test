# file system
resource "oci_file_storage_file_system" "test_fs" {
    availability_domain = "${oci_core_subnet.test_subnet02.availability_domain}"
    compartment_id      = "${var.compartment_ocid}"
    display_name = "test_fs"
}

# mount target
resource "oci_file_storage_mount_target" "test_mount_target" {
    availability_domain = "${oci_core_subnet.test_subnet02.availability_domain}"
    compartment_id = "${var.compartment_ocid}"
    subnet_id = "${oci_core_subnet.test_subnet02.id}"
    display_name = "test_mount_target"
}

# export set
resource "oci_file_storage_export_set" "test_export_set" {
    mount_target_id = "${oci_file_storage_mount_target.test_mount_target.id}"
    display_name = "test_expor_set"
}

# export
resource "oci_file_storage_export" "test_export" {
    export_set_id = "${oci_file_storage_export_set.test_export_set.id}"
    file_system_id = "${oci_file_storage_file_system.test_fs.id}"
    path = "/export-testfs"

    export_options {
        source = "${var.subnet02_cidr_block}"
        access = "READ_WRITE"
        identity_squash = "NONE"
        require_privileged_source_port = "false"
    }
}

# resource "null_resource" "mount_fss_on_instance" {
#     depends_on = ["oci_core_instance.test-web",
#         "oci_file_storage_export.test_export",
#     ]
#     count = "${var.web_num}"

#     provisioner "remote-exec" {
#         connection {
#             agent       = false
#             timeout     = "3m"
#             host        = "${oci_core_instance.test-web.*.private_ip[count.index % var.web_num]}"
#             user        = "opc"
#             private_key = "${var.ssh_private_key}"
#         }

#         inline = [
#             "sudo yum -y install nfs-utils",
#             "sudo mkdir -p /mnt/storage",
#             "sudo chmod 777 /mnt/storage",
#             "sudo mount ${local.nfs_mount_target_ip}:/export-testfs /mnt/storage",
#         ]
#     }
# }