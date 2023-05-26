locals {
  app_name                 = "kube-prometheus-stack"
  adapter_app_name         = "prometheus-adapter"
  prometheus_service_name  = "kube-prometheus-stack-prometheus"
  cert_manager_secret_name = trimspace(var.grafana_tls_secret_name) != "" ? var.grafana_tls_secret_name : join("-", [local.app_name, "certmanager-def.tls"])
}

resource "kubernetes_namespace" "kube_prometheus_stack_namespace" {
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

resource "kubernetes_secret" "kube_prometheus_ingress_auth" {
  metadata {
    name      = "${local.app_name}-basic-auth"
    namespace = var.namespace
    labels = {
      app = local.app_name
    }
  }
  data = {
    username = var.grafana_ingress_basic_auth_username
    password = random_password.basic_auth_password.result
    auth     = "${var.grafana_username}:{PLAIN}${random_password.grafana_admin_password.result}"
  }

  depends_on = [resource.kubernetes_namespace.kube_prometheus_stack_namespace]
}

data "template_file" "kube_prometheus_stack_config" {
  template = templatefile(
    "${path.module}/values/kube-prometheus-stack.yml",
    {
      regcred                             = var.regcred
      grafana_ingress_host                = var.grafana_ingress_host
      grafana_ingress_class               = var.grafana_ingress_class
      grafana_cluster_issuer_name         = var.grafana_cluster_issuer_name
      cert_manager_secret_name            = local.cert_manager_secret_name
      grafana_ingress_basic_auth_username = var.grafana_ingress_basic_auth_username
      grafana_ingress_basic_auth_message  = var.grafana_ingress_basic_auth_message
      grafana_ingress_basic_auth_secret   = trimspace(var.grafana_ingress_basic_auth_username) != "" ? "${var.namespace}/${kubernetes_secret.kube_prometheus_ingress_auth[0].metadata[0].name}" : ""
    }
  )
}

resource "helm_release" "kube_prometheus_stack" {
  name             = local.app_name
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  version          = var.prometheus_stack_chart_version
  create_namespace = true

  values = trimspace(var.prometheus_stack_additional_values) != "" ? [data.template_file.kube_prometheus_stack_config.template, var.prometheus_stack_additional_values] : [data.template_file.kube_prometheus_stack_config.template]

  set_sensitive {
    name  = "grafana.adminPassword"
    value = random_password.grafana_admin_password.result
  }

  depends_on = [resource.kubernetes_secret.kube_prometheus_ingress_auth]
}

data "template_file" "prometheus_adapter_config" {
  template = templatefile(
    "${path.module}/values/prometheus-adapter.yml",
    {
      prometheus_internal_url = "${local.prometheus_service_name}.${var.namespace}.svc"
    }
  )
}

resource "helm_release" "prometheus_adapter" {
  count = trimspace(var.prometheus_adapter_chart_version) != "" ? 1 : 0

  name       = local.adapter_app_name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-adapter"
  namespace  = var.namespace
  version    = var.prometheus_adapter_chart_version

  values = trimspace(var.prometheus_adapter_additional_values) != "" ? [data.template_file.prometheus_adapter_config.template, var.prometheus_adapter_additional_values] : [data.template_file.prometheus_adapter_config.template]
}
