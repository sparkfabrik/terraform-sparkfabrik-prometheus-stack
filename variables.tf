variable "prometheus_stack_chart_version" {
  type = string
  description = "Chart version Prometheus-stack"
}

variable "prometheus_adapter_chart_version" {
  type = string
  description = "Chart version Prometheus Adapter. If the variable is left empty, the Prometheus Adapter Chart will not be installed"
  default = ""
}

variable "namespace" {
  type = string
  description = "This is the namespace used to install kube-prometheus-stack, it will be created."
  default = "kube-prometheus-stack"
}

variable "prometheus_pv_size" {
  type = string
  description = "Prometheus PV size"
  default = "100Gi"
}

variable "regcred" {
  type = string
  description = "Name of the secret docker credential"
}

variable "storage_class_name" {
  type = string
  description = "Storage class name which will be used for the `PersistentVolumes` for Prometheus and Grafana"
  default = ""
}

variable "prometheus_resources" {
  type        = object({ cpu_requests = string, memory_requests = string })
  description = "Prometheus resource"
  default     = {
                  cpu_requests = "",
                  memory_requests = ""
                }
}

variable "prometheus_operator_resources" {
  type        = object({ cpu_requests = string, memory_requests = string })
  description = "PrometheusOperetor resource"
  default     = {
                  cpu_requests = "",
                  memory_requests = ""
                }
}

variable "prometheus_adapter_resources" {
  type        = object({ cpu_requests = string, memory_requests = string })
  description = "PrometheusAdapter resource"
  default     = {
                  cpu_requests = "",
                  memory_requests = ""
                }
}

variable "kube_etcd" {
  type = bool
  description = "Component scraping etcd"
  default = false
}

variable "kube_controller_manager" {
  type = bool
  description = "Component scraping the kube controller manager"
  default = false
}

variable "kube_scheduler" {
  type = bool
  description = "Component scraping kube scheduler"
  default = false
}

variable "alert_manager" {
  type = bool
  description = "Deploy alertmanager"
  default = false
}

# Grafana config.
variable "grafana_ingress_class" {
  type = string
  description = "Ingress Class"
  default = "nginx"
}

variable "grafana_ingress_host" {
  type = string
  description = "Grafana ingress host. If the variable left empty, the ingress not be enabled"
  default = ""
}

variable "grafana_ingress_basic_auth_username" {
  type = string
  description = "Grafana basic auth username (if not empty it will be activated)."
  default = "admin"
}

variable "grafana_ingress_basic_auth_message" {
  type = string
  description = "Grafana basic auth message."
  default = "Authentication Required"
}

variable "grafana_cert_manager_cluster_issuer_name" {
  type = string
  description = "Resource representing the cluster issuer of cert-manager (used to deploy a TLS cert for Grafana ingress). If the variable is left empty, the annotations will not be added"
  default = ""
}

variable "grafana_cert_manager_secret_name" {
  type = string
  description = "cert-manager tls secret name (as this is an helm values file we should pass it manually, we cannot use the release name)"
  default = "grafana-general-tls"
}

variable "grafana_resources" {
  type        = object({ cpu_requests = string, memory_requests = string })
  description = "Grafana resource"
  default     = {
                  cpu_requests = "",
                  memory_requests = ""
                }
}

variable "grafana_pv_size" {
  type = string
  description = "Grafana PV size"
  default = "10Gi"
}
