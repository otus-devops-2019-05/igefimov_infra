output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}

//output "app_lb_external_ip" {
//  value = "${google_compute_global_address.lb-global-ip.address}"
//}

