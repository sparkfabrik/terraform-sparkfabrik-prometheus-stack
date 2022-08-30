variable "prometheus_stack_chart_version" {
  type = string
  description = "Chart version Prometheus-stack."
}

variable "prometheus_adapter_chart_version" {
  type = string
  description = "Chart version Prometheus Adapter. If the variable is left empty, the Prometheus Adapter Chart will not be installed."
  default = ""
}

variable "namespace" {
  type = string
  description = "This is the namespace used to install kube-prometheus-stack."
  default = "kube-prometheus-stack"
}

variable "regcred" {
  type = string
  description = "Name of the secret of the docker credentials."
}

variable "grafana_ingress_host" {
  type = string
  description = "Grafana ingress host. If the variable is left empty, the ingress will not be enabled."
  default = ""
}

variable "grafana_ingress_class" {
  type = string
  description = "Ingress Class"
  default = "nginx"
}

variable "grafana_cluster_issuer_name" {
  type = string
  description = "Resource representing the cluster issuer of cert-manager (used to deploy a TLS certificate for Grafana ingress). If the variable is left empty, the annotations will not be added."
  default = ""
}

variable "grafana_tls_secret_name" {
  type = string
  description = "TLS secret name. If the variable is left empty, the value will be filled by the module using default value."
  default = ""
}

variable "grafana_ingress_basic_auth_username" {
  type = string
  description = "Grafana basic auth username. If the variable is left empty, the basic auth will not be activated and you will use only the standard Grafana authentication."
  default = "admin"
}

variable "grafana_ingress_basic_auth_message" {
  type = string
  description = "Grafana basic auth message."
  default = "Authentication Required"
}

variable "prometheus_stack_additional_values" {
  type = string
  description = "Override values for kube-prometheus-stack release. If this variable is configured, its content will be merged with the other values."
  default = ""
}

variable "prometheus_adapter_additional_values" {
  type = string
  description = "Override values for prometheus-adapter release. If this variable is configured, its content will be merged with the other values."
  default = ""
}

variable "prometheus_path_crd" {
  type    = string
  description = "Overwrite prometheus operator CRDs. If queta variable is configured with the CRDs path the content will overwrite the existing one. By default, version 0.58.0 is installed."
  default = ""
}
