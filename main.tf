# ------
# LOCALS
# ------

locals {
  app_name = "kube-prometheus-stack"
  adapter_app_name = "prometheus-adapter"
  prometheus_service_name = "kube-prometheus-stack-prometheus"
}

data "template_file" "kube_prometheus_stack_config" {
  template = templatefile(
    "${path.module}/values/kube-prometheus-stack.yml",
    {
      storage_class_name = var.storage_class_name
      regcred = var.regcred
      grafana_cert_manager_secret_name = var.grafana_cert_manager_secret_name
      grafana_ingress_host = var.grafana_ingress_host
      grafana_cluster_issuer_name = var.grafana_cert_manager_cluster_issuer_name
      grafana_pv_size = var.grafana_pv_size
      grafana_resources = var.grafana_resources
      grafana_ingress_class = var.grafana_ingress_class
      prometheus_pv_size = var.prometheus_pv_size
      prometheus_resources = var.prometheus_resources
      prometheus_operator_resources = var.prometheus_operator_resources
      kube_etcd = var.kube_etcd
      kube_controller_manager = var.kube_controller_manager
      kube_scheduler = var.kube_scheduler
      alert_manager = var.alert_manager
    }
  )
}

resource "random_password" "grafana_admin_password" {
  length           = 30
  special          = true
  override_special = "_%@"
}

resource "kubernetes_namespace" "kube_prometheus_stack_namespace" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "kubernetes_secret" "kube_prometheus_ingress_auth" {
  count = trimspace(var.grafana_ingress_host) != "" ? 1 : 0
  metadata {
    name      = "${local.app_name}-basic-auth"
    namespace = var.namespace
    labels = {
      app       = local.app_name
    }
  }
  data = {
    username = var.grafana_ingress_basic_auth_username
    password = random_password.grafana_admin_password.result
    auth = "${var.grafana_ingress_basic_auth_username}:{PLAIN}${random_password.grafana_admin_password.result}"
  }

  depends_on = [ resource.kubernetes_namespace.kube_prometheus_stack_namespace ]
}

resource "helm_release" "kube_prometheus_stack" {
  name = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"
  namespace = var.namespace
  version = var.prometheus_stack_chart_version
  create_namespace = true

  values = [data.template_file.kube_prometheus_stack_config.template]

  set_sensitive {
    name = "grafana.adminPassword"
    value = random_password.grafana_admin_password.result
  }

  set {
    name = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-type"
    value = "basic"
  }

  set {
    name = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-realm"
    value = var.grafana_ingress_basic_auth_message
  }

  set {
    name = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/auth-secret"
    value = "${var.namespace}/${kubernetes_secret.kube_prometheus_ingress_auth[0].metadata[0].name}"
  }

  set {
    name = "prometheus-node-exporter.resources.requests.cpu"
    value = "3m"
  }

  set {
    name = "prometheus-node-exporter.resources.requests.memory"
    value = "16Mi"
  }

  depends_on = [ resource.kubernetes_secret.kube_prometheus_ingress_auth ]
}

data "template_file" "prometheus_adapter_config" {
  template = templatefile(
    "${path.module}/values/adapter-values.yml",
    {
      prometheus_internal_url = "${local.prometheus_service_name}.${var.namespace}.svc"
      prometheus_adapter_resources = var.prometheus_adapter_resources
    }
  )
}

resource "helm_release" "prometheus_adapter" {
  count = trimspace(var.prometheus_adapter_chart_version) != "" ? 1 : 0
  name = local.adapter_app_name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "prometheus-adapter"
  namespace = var.namespace
  version = var.prometheus_adapter_chart_version

  values = [data.template_file.prometheus_adapter_config.template]
}
