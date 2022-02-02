variable "namespace" {
  type = string
  default = "kube-prometheus-stack"
}

variable "chart_version" {
  type = string
}

variable "grafana_pv_size" {
  type = string
  default = "10Gi"
}

variable "prometheus_pv_size" {
  type = string
  default = "100Gi"
}

variable "ingress_host" {
  type = string
}

variable "basic_auth_username" {
  type = string
  default = "admin"
}

variable "cluster_issuer_name" {
  type = string
  default = ""
}

variable "install_adapter" {
  type = bool
  default = false
}

variable "grafana_ingress_enabled" {
  type = bool
  default = true
}

variable "adapter_chart_version" {
  type = string
  default = ""
}

variable "pull_secrets" {
  type = bool
}

variable "regcred" {
  type = string
}

variable "secret_name" {
  type = string
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
  default     = { cpu_requests = "", 
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
  default = "Company"
}

variable "ingress_class" {
  type = string
  default = "nginx"
}

variable "kube_etcd" {
  type = bool
  default = false
}

variable "kube_controller_manager" {
  type = bool
  default = false
}

variable "kube_scheduler" {
  type = bool
  default = false
}