<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.18.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.devops-demo-app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.devops-demo-configmap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.devops-demo-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.devops-demo-networkpolicy](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.devops-demo-secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.devops-demo-serivce](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.devops-demo-serivce-lb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [terraform_remote_state.postgres_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | Nome del deployment, utilizzato per identificare tutti gli oggetti deployati | `string` | `"devops-test"` | no |
| <a name="input_image"></a> [image](#input\_image) | Docker image da utilizzare nel deploy | `string` | `"ghcr.io/perceptolab/devops-demo-app:0.0.2"` | no |
| <a name="input_resources_limit_cpu"></a> [resources\_limit\_cpu](#input\_resources\_limit\_cpu) | Valore di cpu limit per l'applicazione | `string` | `"1000m"` | no |
| <a name="input_resources_limit_memory"></a> [resources\_limit\_memory](#input\_resources\_limit\_memory) | Valore di memory limit per l'applicazione | `string` | `"1Gi"` | no |
| <a name="input_resources_reservation_cpu"></a> [resources\_reservation\_cpu](#input\_resources\_reservation\_cpu) | Valore di cpu reservation per l'applicazione | `string` | `"250m"` | no |
| <a name="input_resources_reservation_memory"></a> [resources\_reservation\_memory](#input\_resources\_reservation\_memory) | Valore di memory reservation per l'applicazione | `string` | `"512Mi"` | no |
| <a name="input_spring_profiles"></a> [spring\_profiles](#input\_spring\_profiles) | Profili spring con cui eseguire l'applicazione | `string` | `"prod,kubernetes,monitoring"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->