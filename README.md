## Project Title

**DO-CC1 - Kubernetes and Monitoring**

---

## Descrizione 

Procedura automatizzata per il deploy di un'appliazione web, in un cluster kubenteres.

Il deploy dello stack applicativo si compone di due step, il primo crea un database necessario all'applicazione, il secondo effettua il deploy di tutte le componenti necessarie all'applicazione.

Ai due step precedenti se ne aggiunge un terzo che gestisce la creazione di un calssico stack Prometheus-Grafana per monitorare l'applicazione.

Tutta la procedura di deploy è gestita con Terraform. 
La scelta di questo strumento è dovuta in parte alla flessibilità dei vari provider disponibili e alla gestione degli stati remoti dei vari deploy e la possibilità di essere integrato in strumenti di automazione (ad esempio GitHub Actions, Bitbucket Pipelines)

## Getting Started 
---

## Dipendenze

Terraform v1.4.0 (o superiore)

K3s (o altra distrubuzione Kubernetes)

## Installazione

Per effettuare il deploy dello stack è sufficiente eseguire lo script bash "create_all.sh"

```bash
./create_all.sh
```

avendo cura di configurare il path del config file di kubernetes nei vari terraform.tfvars

Lo script bash, si sposta nelle cartelle del progetto ed esegue da prima l'init per scaricare ed inizializzare i provider necessari al funzionamento delle risorse definite nei file del progetto.

Il secondo step è quello della validazione del codice, in caso di errore termina il deploy

Il passo successivo è quello del plan, ovvero dove recupera lo stato attuale e lo confronta con quello descritto nel codice del progetto, illustrando tutti i cambiamenti che verrebbero apportati.

Come ultimo step viene fatto l'apply delle modifiche.

## Disinstallazione

La rimozione di tutte le risorse è altrettanto facile, basta eseguire lo script bash "destroy_all.sh"

```bash
./destroy_all.sh
```

Il destroy fa il processo inverso del create, si sposta nelle varie cartelle del progetto, ed esegue il destroy di tutte le risorse definite nella cartella del progetto

## Componenti

## postgres

Il primo applicativo ad essere deployato è il database postgres.

Il deploy viene effettuato come già detto utilizzando Terrafomr, in particolare con l'Helm provider, utilizzando l'helm chard bitnami/postgres

Questo step produce un pod postgresql gestito da uno statefulset , senza volume persistente, che comunica con il mondo esterno tramite porta 5432 e il traffico in ingresso su questa porta è regolato da una network policy che permette il traffico solo a pod con label "app: devops-test-app".

Come output di questo step vengono salvate numerose informazioni che saranno poi utilizzate negli step successivi. 
Tra le tante, utente e password del database, ma per ragioni di sicurezza, non sono in chiaro, ma codificate in base64. 
La stessa codifica che verrà poi utilizzata nella definizione della secret relativa all'applicazione.

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

## app

L'applicazione viene deployata utilizzando il manifest, ma non direttamente. 
Il contenuto dello yaml è stato prima "tradotto" per Terraform utilizzando la funzione yamldecode di Terraform

```bash
 echo 'yamldecode(file("resource.yaml"))' | terraform console
```

In qesto modo è stato più semplice utilizzare le variabili, in modo nativo senza dover passare per sostituzioni o altre procedure.

Utilizzando la risorsa remote_state di Terraform, è stato possibile utilizzare i valori di output salvati nello stato durante il deploy del database postgres per configurare automaticamente la connessione al db.

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

## monitoring

Infine giunge il monitoring. Uno stack composto da Grafana e Prometheus.

Sono installati utilizzando i chart helm ufficiali, mediante il provider helm di Terraform.

La configurazione viene eseguita in fase di deploy con i file grafana-values.yaml e prometheus-values-yaml.

Inoltre è stato creato un dashboard custom sulle metriche esposte dall'applicazione, mediante l'utilizzo di una configmap e sfruttando il sidecar container di Grafana, (inserendo la label "grafana_dasboard: dashboard" nella configmap) il dashboard viene caricato in automatico all'avvio di Grafana.

**AlertManager: TO DO

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
