# Terraform Prometheus stack module

![tflint status](https://github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack/actions/workflows/tflint.yml/badge.svg?branch=main)

This is Terraform module to install and configure the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) helm chart. It also allows to control the grafana annotations to secure the grafana access, trough nginx-ingress + cert-manager.

This module could also install the [Prometheus Adapter](https://github.com/helm/charts/tree/master/stable/prometheus-adapter) helm chart.

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
locals {
  prometheus_stack_additional_values = yamlencode({
    commonLabels: {
      label1: "this-is-my-first-label"
      label2: "this-is-my-second-label"
    }
  })
  prometheus_adapter_additional_values = yamlencode({
    resources: {
      requests: {
        cpu: "10m",
        memory: "32Mi"
      }
    }
  })
}

module "kube_prometheus_stack" {
  source = "sparkfabrik/terraform-sparkfabrik-prometheus-stack"

  prometheus_stack_chart_version          = "31.0.0"
  prometheus_adapter_chart_version        = "3.0.1"
  namespace                               = "kube-prometheus-stack"
  regcred                                 = "regcred-secret"
  grafana_ingress_host                    = "monitoring.example.com"
  grafana_ingress_class                   = "nginx"
  grafana_cluster_issuer_name             = "prod-certmanager"
  grafana_tls_secret_name                 = "monitoring-tls"
  grafana_ingress_basic_auth_username     = "admin"
  grafana_ingress_basic_auth_message      = "Grafana basic auth"

  prometheus_stack_additional_values      = local.prometheus_stack_additional_values
  prometheus_adapter_additional_values    = local.prometheus_adapter_additional_values
}
```
