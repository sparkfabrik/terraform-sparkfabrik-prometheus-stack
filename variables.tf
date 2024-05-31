variable "prometheus_stack_chart_version" {
  type        = string
  description = "Chart version Prometheus-stack. You can change the version of the chart to install a different version of the chart, but the shipped values are created for the specified version."
  default     = "59.0.0"
}

variable "prometheus_adapter_enabled" {
  type        = bool
  description = "If true, the Prometheus Adapter Chart will be installed."
  default     = false
}
variable "prometheus_adapter_chart_version" {
  type        = string
  description = "Chart version Prometheus Adapter. If the variable `prometheus_adapter_enabled` is set to `false`, the Prometheus Adapter Chart will not be installed."
  default     = "4.10.0"
}

variable "create_namespace" {
  type        = bool
  description = "If true, the namespace will be created. If false, a namespace called as specified in you var.namespace variable, must exists in your Kubernetes cluster."
  default     = true
}

variable "namespace" {
  type        = string
  description = "This is the namespace used to install kube-prometheus-stack."
  default     = "kube-prometheus-stack"
}

variable "regcred" {
  type        = string
  description = "Name of the secret of the docker credentials."
  default     = ""
}

variable "grafana_ingress_host" {
  type        = string
  description = "Grafana ingress host. If the variable is left empty, the ingress will not be enabled."
  default     = ""
}

variable "grafana_ingress_class" {
  type        = string
  description = "Ingress Class"
  default     = "nginx"
}

variable "grafana_cluster_issuer_name" {
  type        = string
  description = "Resource representing the cluster issuer of cert-manager (used to deploy a TLS certificate for Grafana ingress). If the variable is left empty, the annotations will not be added."
  default     = ""
}

variable "grafana_tls_secret_name" {
  type        = string
  description = "TLS secret name. If the variable is left empty, the value will be filled by the module using default value."
  default     = ""
}

variable "grafana_ingress_basic_auth_username" {
  type        = string
  description = "Grafana basic auth username. If the variable is left empty, the basic auth will not be activated and you will use only the standard Grafana authentication."
  default     = "admin"
}

variable "grafana_admin_user" {
  type        = string
  description = "Grafana basic auth username. If the variable is left empty, the basic auth will not be activated and you will use only the standard Grafana authentication."
  default     = "admin"
}

variable "grafana_ingress_basic_auth_message" {
  type        = string
  description = "Grafana basic auth message."
  default     = "Authentication Required"
}

variable "prometheus_stack_additional_values" {
  type        = list(string)
  description = "Override values for kube-prometheus-stack release. If this variable is not an empy list, it will be merged with the other values."
  default     = []
}

variable "prometheus_adapter_additional_values" {
  type        = list(string)
  description = "Override values for prometheus-adapter release. If this variable is not an empy list, it will be merged with the other values."
  default     = []
}
