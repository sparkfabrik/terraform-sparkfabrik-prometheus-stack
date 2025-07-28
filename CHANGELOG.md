# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [5.0.0] - 2025-07-28

[Compare with previous version](https://github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack/compare/4.0.0...5.0.0)

⚠️ **BREAKING CHANGES** ⚠️

The Helm provider version has been updated from 2.x to 3.0. This upgrade introduces significant breaking changes that must be implemented for everything to work correctly.

**Required actions**:

- Update provider configuration: Ensure that the Helm provider version in your project is at least 3.0.
- Follow the official guide: Consult the official Helm provider [migration guide](https://github.com/hashicorp/terraform-provider-helm/blob/1efcb0eb9fb57b89a5da101040d3dff2fea2e204/docs/guides/v3-upgrade-guide.md) to implement all necessary changes.
- Test the configuration: Verify that all components work correctly after the upgrade.

## [4.0.0] - 2024-05-31

[Compare with previous version](https://github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack/compare/3.0.0...4.0.0)

⚠️ **BREAKING CHANGES** ⚠️

In the previous version, if the `prometheus_adapter_chart_version` variable was set, the module enabled the Prometheus Adapter installation. **This behavior has been changed**. Now, to enable the Prometheus Adapter installation, you must set the `prometheus_adapter_enabled` variable to `true`. The `prometheus_adapter_chart_version` variable is now optional and is used if you want to specify a different chart version from the default one. Remember that the shipped chart values are specific to the default chart version.

**If you are not using the Prometheus Adapter (you do not specify the `prometheus_adapter_chart_version` variable in your configuration)**, you can safely ignore this breaking change.

If you receive the following error message during the upgrade:

```bash
cannot patch "kube-prometheus-stack-prometheus-node-exporter" with kind DaemonSet: DaemonSet.apps "kube-prometheus-stack-prometheus-node-exporter" is invalid: spec.selector: Invalid value: v1.LabelSelector{MatchLabels:map[string]string{"app.kubernetes.io/instance":"kube-prometheus-stack", "app.kubernetes.io/name":"prometheus-node-exporter"}, MatchExpressions:[]v1.LabelSelectorRequirement(nil)}: field is immutable
```

you can delete the `DaemonSet` (`kubectl delete daemonsets kube-prometheus-stack-prometheus-node-exporter`) resource and apply the changes again. The helm release will recreate the `DaemonSet` resource with the correct selector. The only drawback is that you will lose the metrics collected by the `DaemonSet` during the downtime.

### Added

- Add the default versions for `prometheus_stack_chart_version` and `prometheus_adapter_chart_version` variables. These values indicate the default chart version to use and the reference to the shipped chart values.
- Add the `prometheus_adapter_enabled` variable to enable or disable the Prometheus Adapter installation.

## [3.0.0] - 2023-11-30

[Compare with previous version](https://github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack/compare/2.1.0...3.0.0)

### Changed

- refs platform/#2586: the `prometheus_stack_additional_values` and `prometheus_adapter_additional_values` variables are now lists of strings instead of a single string. This allows to pass multiple values to the chart.
- The kubernetes resources are now created using the `v1` version.
- The `template_file` data sources are replaced with `templatefile` function calls.

### Added

- The `versions.tf` file is now present in the module root directory.

## [2.1.0] - 2023-06-13

### Added

- `grafana_admin_user` output variable.

## [2.0.0] - 2023-05-26

### Added

- [BREAKING] - added a `create_namespace` variable to disable namespace creation, default: `true`. The namespace is now an array resource. To prevent namespace recreation, use a move resource. See README.md for an example.
- `grafana_admin_user` variable to specify different user, default is `admin`.

### Changed

- Generate different `grafana` and `basic_auth` passwords.

## [1.1.0] - 2022-09-07

## [1.0.0] - 2022-02-11

### Added

- Initial Release
