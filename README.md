# Terraform Prometheus stack module

![tflint status](https://github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack/actions/workflows/tflint.yml/badge.svg?branch=main)

This is Terraform module to install and configure the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) helm chart, it also allows to control the grafana annotations to secure the grafana access, trough nginx-ingress + cert-manager.

This module is provided without any kind of warranty and is GPL3 licensed.

# Configuration Helm and Kubernetes providers

```
provider "kubernetes" {
  host                   = # reference cluster endpoint
  cluster_ca_certificate = # reference cluster ca certificate base64decode
  token                  = # reference access token
}

provider "helm" {
  kubernetes {
    host                   = # reference cluster endpoint
    cluster_ca_certificate = # reference cluster ca certificate base64decode
    token                  = # reference access token
  }
}
```

# Usage

```
module "kube_prometheus_stack" {
  source = "sparkfabrik/terraform-sparkfabrik-prometheus-stack"
  prometheus_stack_chart_version = "32.0.0"
  prometheus_adapter_chart_version = "3.0.1"
  namespace = "prometheus-stack"
  prometheus_pv_size = "10Gi"
  regcred = "" # docker credentials
  kube_etcd = true
  kube_controller_manager = true
  kube_scheduler = true
  grafana_ingress_class = "nginx"
  grafana_ingress_host = "monitoring.example.com"
  grafana_ingress_basic_auth_username = "admin" # username basic auth Ingress
  grafana_ingress_basic_auth_message = "Authentication Required" # basic auth messages
  grafana_cert_manager_cluster_issuer_name = "production-tls"
  grafana_cert_manager_secret_name = "monitoring-tls" # secret name tls
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
}
```
