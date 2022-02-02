output "grafana_admin_password" {
  sensitive = true
  value = random_password.grafana_admin_password.result
  description = "Grafana administrator password"
}
