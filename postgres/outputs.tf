# Utilizzando gli output, fisso nello stato di questo deply i valori dei parametri che 
# saranno utilizzati per gli step successivi del deploy.
output "namespace" {
  value = var.namespace
  description = "Namespace per il deploy"
}

output "helm_chart" {
  value = resource.helm_release.postgres.chart
  description = "Helm chart name, utilizzato per il deploy dell'app"
}

output "distribution_name" {
  value = resource.helm_release.postgres.name
  description = "Helm distribution name, utilizzato per il deploy dell'app"
}

output "postgres_db_port" {
  value = var.db_port
  description = "Postgres port, utilizzata per il deploy dell'app"
}

output "postgres_db_name" {
  value = var.db_name
  description = "Postgres port, utilizzato per il deploy dell'app"
}

output "postgres_db_password" {
  value = base64encode(var.db_password)
  description = "Postgres password, codificata in base64 utilizzata per il deploy dell'app"
}

output "postgres_db_user" {
  value = base64encode(var.db_user)
  description = "Postgres user, codificato in base64 utilizzato per il deploy dell'app"
}

output "kubeconfig_file_path" {
  value = var.kube_config
  description = "Path del file di autenticazione del cluster Kubernetes"
}