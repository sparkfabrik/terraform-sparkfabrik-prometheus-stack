locals {
  app_name_stack           = "kube-prometheus-stack"
  app_name_adapter         = "prometheus-adapter"
  prometheus_service_name  = "kube-prometheus-stack-prometheus"
  cert_manager_secret_name = trimspace(var.grafana_tls_secret_name) != "" ? var.grafana_tls_secret_name : join("-", [local.app_name_stack, "certmanager-def.tls"])

  # Kubernetes Prometheus Stack values
  base_kube_prometheus_stack = templatefile(
    "${path.module}/values/kube-prometheus-stack.yml",
    {
      regcred                             = var.regcred
      grafana_ingress_host                = var.grafana_ingress_host
      grafana_ingress_class               = var.grafana_ingress_class
      grafana_cluster_issuer_name         = var.grafana_cluster_issuer_name
      cert_manager_secret_name            = local.cert_manager_secret_name
      grafana_ingress_basic_auth_username = var.grafana_ingress_basic_auth_username
      grafana_ingress_basic_auth_message  = var.grafana_ingress_basic_auth_message
      grafana_ingress_basic_auth_secret   = trimspace(var.grafana_ingress_basic_auth_username) != "" ? "${var.namespace}/${kubernetes_secret_v1.kube_prometheus_ingress_auth[0].metadata[0].name}" : ""
    }
  )
  kube_prometheus_stack_values = concat(
    [local.base_kube_prometheus_stack],
    var.prometheus_stack_additional_values
  )

  # Prometheus Adapter values
  base_prometheus_adapter = templatefile(
    "${path.module}/values/prometheus-adapter.yml",
    {
      prometheus_internal_url = "${local.prometheus_service_name}.${var.namespace}.svc"
    }
  )
  prometheus_adapter_values = concat(
    [local.base_prometheus_adapter],
    var.prometheus_adapter_additional_values
  )
}

resource "kubernetes_namespace_v1" "kube_prometheus_stack_namespace" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "random_password" "basic_auth_password" {
  length           = 30
  special          = true
  override_special = "_%@"
}

resource "random_password" "grafana_admin_password" {
  length           = 30
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret_v1" "kube_prometheus_ingress_auth" {
  count = trimspace(var.grafana_ingress_basic_auth_username) != "" ? 1 : 0

  metadata {
    name      = "${local.app_name_stack}-basic-auth"
    namespace = kubernetes_namespace_v1.kube_prometheus_stack_namespace[0].metadata[0].name
    labels = {
      app = local.app_name_stack
    }
  }
  data = {
    username = var.grafana_ingress_basic_auth_username
    password = random_password.basic_auth_password.result
    auth     = "${var.grafana_ingress_basic_auth_username}:{PLAIN}${random_password.basic_auth_password.result}"
  }

  type = "kubernetes.io/basic-auth"
}

resource "helm_release" "kube_prometheus_stack" {
  name       = local.app_name_stack
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.create_namespace ? kubernetes_namespace_v1.kube_prometheus_stack_namespace[0].metadata[0].name : var.namespace
  version    = var.prometheus_stack_chart_version

  values = local.kube_prometheus_stack_values

  set_sensitive = [
    {
      name  = "grafana.adminPassword"
      value = random_password.grafana_admin_password.result
    },
    {
      name  = "grafana.adminUser"
      value = var.grafana_admin_user
    }
  ]

  depends_on = [kubernetes_secret_v1.kube_prometheus_ingress_auth]
}

resource "helm_release" "prometheus_adapter" {
  count = var.prometheus_adapter_enabled ? 1 : 0

  name       = local.app_name_adapter
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-adapter"
  namespace  = kubernetes_namespace_v1.kube_prometheus_stack_namespace[0].metadata[0].name
  version    = var.prometheus_adapter_chart_version

  values = local.prometheus_adapter_values
}
