# Definizione delle variabili utilizzate nel deploy dell'applicazione.
# Per tutte le variabili sono presenti dei valori di default, che però possono
# essere sovrascritti da quelli definiti nel file terraform.tfvars
# che solitamente viene ignorato tramite .gitignore per ragioni di sicurezza
variable "kube_config" {
  type    = string
  default = "~/.kube/config"
  #default = "./resources/config"
  description = "Path del kubeconfig file"
}

variable "namespace" {
  type    = string
  default = "perceptolab"
  description = "Namespace dove sarà deployata lo stack applicativo"
}

variable "helm_chart" {
  type    = string
  default = "bitnami/postgresql"
  description = "Nome dell' Helm chart di Postgresql"
}

variable "helm_distribution_name" {
  type    = string
  default = "postgres"
  description = "Nome della distribuzione di Postgresql"
}

variable "helm_repository" {
  type    = string
  default = "https://charts.bitnami.com/bitnami"
  description = "URL dell'Helm chart di Postgresql"
}

variable "db_password" {
    #global.postgresql.auth.postgresPassword
  type = string
  description = "Password dell'utente amministratore"
}

variable "db_port" {
  #global.postgresql.service.ports.postgresql
  type = string
  default = "5432"
  description = "Porta del database"  
}

variable "db_name" {
  #global.postgresql.auth.database
  type = string
  default = "devops-demo-db"
  description = "Nome del database"
}

variable "db_user" {
  #global.postgresql.auth.username
  type = string
  default = "postgres"
  description = "Nome dell'utente amministratore"
}