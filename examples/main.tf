module "kube_prometheus_stack" {
  source = "sparkfabrik/terraform-sparkfabrik-prometheus-stack"
  prometheus_stack_chart_version = "31.0.0"
  prometheus_adapter_chart_version = "3.0.1"
  namespace = "prometheus-stack"
  prometheus_pv_size = "10Gi"
  regcred = ""
  kube_etcd = true
  kube_controller_manager = true
  kube_scheduler = true
  alert_manager = true
  grafana_ingress_class = "nginx"
  grafana_ingress_host = "monitoring.example.com"
  grafana_ingress_basic_auth_username = "admin"
  grafana_ingress_basic_auth_message = "Authentication Required"
  grafana_cert_manager_cluster_issuer_name = "production-tls"
  grafana_cert_manager_secret_name = "monitoring-tls"
  grafana_pv_size = "10Gi"
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
  kube_state_metrics_resources = {
      cpu_requests    = "2m"
      memory_requests = "64Mi"
  }
}
