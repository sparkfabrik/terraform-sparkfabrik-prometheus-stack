# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
