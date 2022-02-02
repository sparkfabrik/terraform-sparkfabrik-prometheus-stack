variable "namespace" {
  type = string
  description = "Namespace Prometheus Stack"
  default = "kube-prometheus-stack"
}

variable "chart_version" {
  type = string
  description = "Chart version Prometheus-stack"
}

variable "grafana_pv_size" {
  type = string
  description = "Grafana Persistence Volume"
  default = "10Gi"
}

variable "prometheus_pv_size" {
  type = string
  description = "Prometheus Persistence Volume"
  default = "100Gi"
}

variable "ingress_host" {
  type = string
  description = "DNS Grafana"
}

variable "basic_auth_username" {
  type = string
  description = "Username Basic Auth"
  default = "admin"
}

variable "cluster_issuer_name" {
  type = string
  description = "Resource representing the certification authority (CA)"
  default = ""
}

variable "install_adapter" {
  type = bool
  description = "Enable Prometheus Adapter"
  default = false
}

variable "grafana_ingress_enabled" {
  type = bool
  description = "Enable Ingress for Grafana"
  default = true
}

variable "adapter_chart_version" {
  type = string
  description = "Chart version Prometheus Adapter"
  default = ""
}

variable "pull_secrets" {
  description = "Enable imagePullSecrets connect with docker hub"
  type = bool
}

variable "regcred" {
  type = string
  description = "Name of the secret docker credential"
}

variable "secret_name" {
  type = string
  description = "Cert-manager secretName"
}

variable "storage_class_name" {
  type = string
  default = ""
}

variable "prometheus_resources" {
  type        = any
  description = "Prometheus resource"
  default     = { 
                  cpu_requests = "", 
                  memory_requests = "" 
                }
}

variable "prometheus_operator_resources" {
  type        = any
  description = "PrometheusOperetor resource"
  default     = { 
                  cpu_requests = "", 
                  memory_requests = "" 
                }
}

variable "grafana_resources" {
  type        = any
  description = "Grafana resource"
  default     = { 
                  cpu_requests = "", 
                  memory_requests = "" 
                }
}

variable "prometheus_adapter_resources" {
  type        = any
  description = "PrometheusAdapter resource"
  default     = { 
                  cpu_requests = "", 
                  memory_requests = "" 
                }
}

variable "company" {
  type = string
  description = "The name of the company displayed on grafana"
  default = "Company"
}

variable "ingress_class" {
  type = string
  description = "Ingress Class"
  default = "nginx"
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
  descdescription = "Component scraping kube scheduler"
  default = false
}