# common
variable "instance_shape" {}
variable "CentOS7" {
    type = "map"
    default = {
        ap-tokyo-1  = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaatq7pw2e6t4ushlnkas2e2bqyql7nmtfpafxunoblndpqadhn3h3a"
        ap-osaka-1 = "ocid1.image.oc1.ap-osaka-1.aaaaaaaa2pmn54xv2awwtrmmthvlhnt6fsmxzise6suxcvaa335q6evevnxq"
        }
    }

# variable "ssh_private_key" {}
variable "ssh_public_key" {}

# public
variable "bastion_num" {}
variable "bastion_display_name" {}

# private
variable "web_num" {}
variable "web_display_name" {}


