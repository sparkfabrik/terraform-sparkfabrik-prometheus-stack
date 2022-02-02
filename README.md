# Terraform Prometheus stack module

# Configuration Helm and Kubernetes provider

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
  namespace = "prometheus-stack"
  grafana_pv_size = "10"
  prometheus_pv_size = "10"
  chart_version = "v31.0.0"
  ingress_host = "monitoring.example.com"
  basic_auth_username = "admin" # username prometheus 
  cluster_issuer_name = "production-tls"
  install_adapter = "false"
  adapter_chart_version = "3.0.1"
  regcred = "" # docker credentials
  pull_secrets = ""
  secret_name = "monitoring-tls" # secret name tls
  storage_class_name = ""
  company = "Sparkfabrik"
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