# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

---

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
