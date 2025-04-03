output "user_data" {
  value = data.cloudinit_config.user_data.rendered
}