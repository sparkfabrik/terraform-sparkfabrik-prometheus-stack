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

# Upgrading from 3.Y.Z to 4.0.0

For the upgrading note, see the [CHANGELOG](./CHANGELOG.md#400---2024-05-31) note for the `4.0.0` release.

# Upgrading from 2.Y.Z to 3.0.0

Upgrading to `3.0.0` from `2.Y.Z` will cause the destruction of the namespace and the basic auth secret.
You will need to remove these resources from the state and import them in the new `v1` resources.

```bash
# Remove the resources from the state
terraform state rm 'module.MODULE_NAME.kubernetes_namespace.kube_prometheus_stack_namespace[0]'
terraform state rm 'module.MODULE_NAME.kubernetes_secret.kube_prometheus_ingress_auth[0]'

# Import the resources in the new v1 resources
terraform import 'module.MODULE_NAME.kubernetes_namespace_v1.kube_prometheus_stack_namespace[0]' kube-prometheus-stack
terraform import 'module.MODULE_NAME.kubernetes_secret_v1.kube_prometheus_ingress_auth[0]' kube-prometheus-stack/kube-prometheus-stack-basic-auth
```

Because of the change of the the `prometheus_stack_additional_values` and `prometheus_adapter_additional_values` variable types, from `string` to `list(string)`, you will need to change the way you pass the values to the module. If you are using a single value, you only need to wrap it in a list, as shown below:

```hcl
prometheus_stack_additional_values = [
  templatefile(
    "${path.module}/files/kube-prometheus-stack/values.yaml",
    {
      var01 = "value01"
      var02 = "value02"
    }
  )
]
```

# Updgrade from 1.1.0 to 2.0.0

Upgrading to 2.0.0 from 1.1.0 will destroy and recreate the basic auth password, which is now different from Grafana admin password,
and will update the relative basic auth secret value.

Upgrading to version 2.0.0 will also cause the destruction of the namespace, which now becomes an array.
This implies that it will have to destroy also the Helm release.
To avoid destruction of the Helm release, you will need to use the `moved` resource, to move the namespace as shown below:

```
moved {
  from = module.MODULE_NAME.kubernetes_namespace.kube_prometheus_stack_namespace
  to   = moudle.MODULE_NAME.kubernetes_namespace.kube_prometheus_stack_namespace[0]
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.23 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | If true, the namespace will be created. If false, a namespace called as specified in you var.namespace variable, must exists in your Kubernetes cluster. | `bool` | `true` | no |
| <a name="input_grafana_admin_user"></a> [grafana\_admin\_user](#input\_grafana\_admin\_user) | Grafana basic auth username. If the variable is left empty, the basic auth will not be activated and you will use only the standard Grafana authentication. | `string` | `"admin"` | no |
| <a name="input_grafana_cluster_issuer_name"></a> [grafana\_cluster\_issuer\_name](#input\_grafana\_cluster\_issuer\_name) | Resource representing the cluster issuer of cert-manager (used to deploy a TLS certificate for Grafana ingress). If the variable is left empty, the annotations will not be added. | `string` | `""` | no |
| <a name="input_grafana_ingress_basic_auth_message"></a> [grafana\_ingress\_basic\_auth\_message](#input\_grafana\_ingress\_basic\_auth\_message) | Grafana basic auth message. | `string` | `"Authentication Required"` | no |
| <a name="input_grafana_ingress_basic_auth_username"></a> [grafana\_ingress\_basic\_auth\_username](#input\_grafana\_ingress\_basic\_auth\_username) | Grafana basic auth username. If the variable is left empty, the basic auth will not be activated and you will use only the standard Grafana authentication. | `string` | `"admin"` | no |
| <a name="input_grafana_ingress_class"></a> [grafana\_ingress\_class](#input\_grafana\_ingress\_class) | Ingress Class | `string` | `"nginx"` | no |
| <a name="input_grafana_ingress_host"></a> [grafana\_ingress\_host](#input\_grafana\_ingress\_host) | Grafana ingress host. If the variable is left empty, the ingress will not be enabled. | `string` | `""` | no |
| <a name="input_grafana_tls_secret_name"></a> [grafana\_tls\_secret\_name](#input\_grafana\_tls\_secret\_name) | TLS secret name. If the variable is left empty, the value will be filled by the module using default value. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | This is the namespace used to install kube-prometheus-stack. | `string` | `"kube-prometheus-stack"` | no |
| <a name="input_prometheus_adapter_additional_values"></a> [prometheus\_adapter\_additional\_values](#input\_prometheus\_adapter\_additional\_values) | Override values for prometheus-adapter release. If this variable is not an empy list, it will be merged with the other values. | `list(string)` | `[]` | no |
| <a name="input_prometheus_adapter_chart_version"></a> [prometheus\_adapter\_chart\_version](#input\_prometheus\_adapter\_chart\_version) | Chart version Prometheus Adapter. If the variable `prometheus_adapter_enabled` is set to `false`, the Prometheus Adapter Chart will not be installed. | `string` | `"4.10.0"` | no |
| <a name="input_prometheus_adapter_enabled"></a> [prometheus\_adapter\_enabled](#input\_prometheus\_adapter\_enabled) | If true, the Prometheus Adapter Chart will be installed. | `bool` | `false` | no |
| <a name="input_prometheus_stack_additional_values"></a> [prometheus\_stack\_additional\_values](#input\_prometheus\_stack\_additional\_values) | Override values for kube-prometheus-stack release. If this variable is not an empy list, it will be merged with the other values. | `list(string)` | `[]` | no |
| <a name="input_prometheus_stack_chart_version"></a> [prometheus\_stack\_chart\_version](#input\_prometheus\_stack\_chart\_version) | Chart version Prometheus-stack. You can change the version of the chart to install a different version of the chart, but the shipped values are created for the specified version. | `string` | `"59.0.0"` | no |
| <a name="input_regcred"></a> [regcred](#input\_regcred) | Name of the secret of the docker credentials. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_admin_password"></a> [grafana\_admin\_password](#output\_grafana\_admin\_password) | Grafana administrator password |
| <a name="output_grafana_admin_user"></a> [grafana\_admin\_user](#output\_grafana\_admin\_user) | Grafana administrator username |

## Resources

| Name | Type |
|------|------|
| [helm_release.kube_prometheus_stack](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus_adapter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.kube_prometheus_stack_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.kube_prometheus_ingress_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [random_password.basic_auth_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Modules

No modules.


<!-- END_TF_DOCS -->
