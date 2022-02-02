module "kube_prometheus_stack" {
  source = "sparkfabrik/terraform-sparkfabrik-prometheus-stack"
  namespace = "kube-prometheus-stack"
  grafana_pv_size = "20"
  prometheus_pv_size = "20"
  chart_version = "v30.2.0"
  ingress_host = "monitoring.example.com"
  basic_auth_username = "admin"
  cluster_issuer_name = "prod-certmanager"
  install_adapter = "true"
  adapter_chart_version = "3.0.1"
  regcred = "true"
  pull_secrets = "docker"
  secret_name = "monitoring-tls"
  storage_class_name = "gp2"
  prometheus_resources = {
    cpu_requests    = "50m"
    memory_requests = "1Gi"
  }
  prometheus_operator_resources = {
    cpu_requests    = "50m"
    memory_requests = "1Gi"
  }
  grafana_resources = {
    cpu_requests    = "50m"
    memory_requests = "1Gi"
  }
  prometheus_adapter_resources = {
    cpu_requests    = "500m"
    memory_requests = "1Gi"
  }
  company = "Sparkfabrik"
}