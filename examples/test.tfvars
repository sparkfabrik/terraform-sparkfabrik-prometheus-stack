chart_version = "v30.2.0"
namespace = "kube-prometheus-stack"
regcred = "true"
storage_class_name = "gp2"
prometheus_pv_size = "20"
prometheus_install_adapter = "true"
prometheus_adapter_chart_version = "3.0.1"
prometheus_resources = {
    cpu_requests    = "50m"
    memory_requests = "1Gi"
}
prometheus_operator_resources = {
    cpu_requests    = "50m"
    memory_requests = "1Gi"
}
prometheus_adapter_resources = {
    cpu_requests    = "500m"
    memory_requests = "1Gi"
}
kube_etcd = true
kube_controller_manager = true
kube_scheduler = true
grafana_ingress_enabled = true
grafana_ingress_class = "nginx"
grafana_ingress_host = "monitoring.example.com"
grafana_ingress_basic_auth_message = "Grafana basic auth"
grafana_basic_auth_username = "admin"
grafana_cert_manager_cluster_issuer_name = "prod-certmanager"
grafana_cert_manager_secret_name = "monitoring-tls"
grafana_resources = {
    cpu_requests    = "50m"
    memory_requests = "1Gi"
}
grafana_pv_size = "20"
