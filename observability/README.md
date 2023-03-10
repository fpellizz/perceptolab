<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.9.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.18.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.grafana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map.application_dashboard](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_secret.grafana](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_password.grafana](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [terraform_remote_state.postgres_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_grafana_chart"></a> [grafana\_chart](#input\_grafana\_chart) | Nome del chart Helm di Grafana | `string` | `"grafana"` | no |
| <a name="input_grafana_name"></a> [grafana\_name](#input\_grafana\_name) | Nome della distribuzione di Grafana | `string` | n/a | yes |
| <a name="input_grafana_repository"></a> [grafana\_repository](#input\_grafana\_repository) | URL del repository Helm di Grafana | `string` | `"https://grafana.github.io/helm-charts"` | no |
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | Versione di Grafana | `string` | `"6.52.1"` | no |
| <a name="input_prometheus_chart"></a> [prometheus\_chart](#input\_prometheus\_chart) | Nome del chart Helm di Prometheus | `string` | `"prometheus"` | no |
| <a name="input_prometheus_name"></a> [prometheus\_name](#input\_prometheus\_name) | Nome della distribuzione di Prometheus | `string` | `"prometheus"` | no |
| <a name="input_prometheus_repository"></a> [prometheus\_repository](#input\_prometheus\_repository) | URL del repository Helm di Prometheus | `string` | `"https://prometheus-community.github.io/helm-charts"` | no |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | Versione di Prometheus | `string` | `"19.7.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_password"></a> [grafana\_password](#output\_grafana\_password) | Password per accedere a grafana |
<!-- END_TF_DOCS -->