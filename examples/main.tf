locals {
  prometheus_stack_additional_values = yamlencode({
    commonLabels : {
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
  prometheus_path_crd = "${path.module}/crd/*.yaml"
}

module "kube_prometheus_stack" {
  source = "sparkfabrik/terraform-sparkfabrik-prometheus-stack"

  prometheus_stack_chart_version       = var.prometheus_stack_chart_version
  prometheus_adapter_chart_version     = var.prometheus_adapter_chart_version
  namespace                            = var.namespace
  regcred                              = var.regcred
  grafana_ingress_host                 = var.grafana_ingress_host
  grafana_ingress_class                = var.grafana_ingress_class
  grafana_cluster_issuer_name          = var.grafana_cluster_issuer_name
  grafana_tls_secret_name              = var.grafana_tls_secret_name
  grafana_ingress_basic_auth_username  = var.grafana_ingress_basic_auth_username
  grafana_ingress_basic_auth_message   = var.grafana_ingress_basic_auth_message
  prometheus_stack_additional_values   = local.prometheus_stack_additional_values
  prometheus_adapter_additional_values = local.prometheus_adapter_additional_values
  prometheus_path_crd_override         = local.prometheus_path_crd
}
