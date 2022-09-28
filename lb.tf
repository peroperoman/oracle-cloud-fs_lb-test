resource "oci_load_balancer" "web-lb" {
    shape          = "100Mbps"
    compartment_id = "${var.compartment_ocid}"

    subnet_ids = [
        "${oci_core_subnet.test_subnet01.id}",
    ]
    display_name               = "test-Web-lb"
    is_private                 = false
}

resource "oci_load_balancer_backend_set" "test_backend_set" {
    name             = "lb-backend"
    load_balancer_id = "${oci_load_balancer.web-lb.id}"
    policy           = "LEAST_CONNECTIONS"

    health_checker {
        port                = "80"
        protocol            = "HTTP"
        response_body_regex = ".*"
        url_path            = "/"
    }

    lb_cookie_session_persistence_configuration {
        cookie_name        = "test_cookie"
        domain             = "test-web.jp"
        is_http_only       = false
        is_secure          = false
        max_age_in_seconds = 10
        path               = "/"
        disable_fallback   = true
    }
}

resource "oci_load_balancer_backend" "test_backend01" {
    backendset_name = "${oci_load_balancer_backend_set.test_backend_set.name}"
    ip_address = "${oci_core_instance.test-web.*.private_ip[0]}"
    load_balancer_id = "${oci_load_balancer.web-lb.id}"
    port = "80"
}

resource "oci_load_balancer_backend" "test_backend02" {
    backendset_name = "${oci_load_balancer_backend_set.test_backend_set.name}"
    ip_address = "${oci_core_instance.test-web.*.private_ip[1]}"
    load_balancer_id = "${oci_load_balancer.web-lb.id}"
    port = "80"
}

resource "oci_load_balancer_rule_set" "https_enable_rule" {
    items {
        action = "ADD_HTTP_REQUEST_HEADER"
        description = "test-setting"
        header = "X-LoadBalancer"
        value = "ssl"
    }
    load_balancer_id = "${oci_load_balancer.web-lb.id}"
    name = "https_enable_rule"
}

resource "oci_load_balancer_certificate" "cert" {
    load_balancer_id   = "${oci_load_balancer.web-lb.id}"
    ca_certificate     = "{BEGIN CERTIFICATE}"
    certificate_name   = "{CERTIFICATE NAME}"
    private_key        = "{BEGIN PRIVATE KEY}"
    public_certificate = "{BEGIN CERTIFICATE}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "oci_load_balancer_listener" "listener-http" {
    load_balancer_id         = "${oci_load_balancer.web-lb.id}"
    name                     = "http"
    default_backend_set_name = "${oci_load_balancer_backend_set.test_backend_set.name}"
    port                     = 80
    protocol                 = "HTTP"

    connection_configuration {
        idle_timeout_in_seconds = "2"
    }
}

resource "oci_load_balancer_listener" "listener-https" {
    load_balancer_id         = "${oci_load_balancer.web-lb.id}"
    name                     = "https"
    default_backend_set_name = "${oci_load_balancer_backend_set.test_backend_set.name}"
    port                     = 443
    protocol                 = "HTTP"
    rule_set_names = ["${oci_load_balancer_rule_set.https_enable_rule.name}"]

    ssl_configuration {
        certificate_name        = "${oci_load_balancer_certificate.cert.certificate_name}"
        verify_peer_certificate = false
    }
}
