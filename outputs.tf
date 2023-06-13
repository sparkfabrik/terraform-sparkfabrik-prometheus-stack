output "grafana_admin_password" {
  sensitive = true
  value = random_password.grafana_admin_password.result
  description = "Grafana administrator password"
}

output "grafana_admin_user" {
  value = var.grafana_admin_user
  description = "Grafana administrator username"
}
