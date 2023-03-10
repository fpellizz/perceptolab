<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.9.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.18.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.postgres](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nome del database | `string` | `"devops-demo-db"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Password dell'utente amministratore | `string` | n/a | yes |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | Porta del database | `string` | `"5432"` | no |
| <a name="input_db_user"></a> [db\_user](#input\_db\_user) | Nome dell'utente amministratore | `string` | `"postgres"` | no |
| <a name="input_helm_chart"></a> [helm\_chart](#input\_helm\_chart) | Nome dell' Helm chart di Postgresql | `string` | `"bitnami/postgresql"` | no |
| <a name="input_helm_distribution_name"></a> [helm\_distribution\_name](#input\_helm\_distribution\_name) | Nome della distribuzione di Postgresql | `string` | `"postgres"` | no |
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | URL dell'Helm chart di Postgresql | `string` | `"https://charts.bitnami.com/bitnami"` | no |
| <a name="input_kube_config"></a> [kube\_config](#input\_kube\_config) | Path del kubeconfig file | `string` | `"~/.kube/config"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace dove sarà deployata lo stack applicativo | `string` | `"perceptolab"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_distribution_name"></a> [distribution\_name](#output\_distribution\_name) | Helm distribution name, utilizzato per il deploy dell'app |
| <a name="output_helm_chart"></a> [helm\_chart](#output\_helm\_chart) | Helm chart name, utilizzato per il deploy dell'app |
| <a name="output_kubeconfig_file_path"></a> [kubeconfig\_file\_path](#output\_kubeconfig\_file\_path) | Path del file di autenticazione del cluster Kubernetes |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace per il deploy |
| <a name="output_postgres_db_name"></a> [postgres\_db\_name](#output\_postgres\_db\_name) | Postgres port, utilizzato per il deploy dell'app |
| <a name="output_postgres_db_password"></a> [postgres\_db\_password](#output\_postgres\_db\_password) | Postgres password, codificata in base64 utilizzata per il deploy dell'app |
| <a name="output_postgres_db_port"></a> [postgres\_db\_port](#output\_postgres\_db\_port) | Postgres port, utilizzata per il deploy dell'app |
| <a name="output_postgres_db_user"></a> [postgres\_db\_user](#output\_postgres\_db\_user) | Postgres user, codificato in base64 utilizzato per il deploy dell'app |
<!-- END_TF_DOCS -->