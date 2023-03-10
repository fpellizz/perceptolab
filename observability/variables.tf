# Definizione delle variabili utilizzate nel deploy dell'applicazione.
# Per tutte le variabili sono presenti dei valori di default, che però possono
# essere sovrascritti da quelli definiti nel file terraform.tfvars
# che solitamente viene ignorato tramite .gitignore per ragioni di sicurezza

variable "prometheus_chart" {
  type    = string
  default = "prometheus"
  description = "Nome del chart Helm di Prometheus"
}

variable "prometheus_name" {
  type    = string
  default = "prometheus"
  description = "Nome della distribuzione di Prometheus"
}

variable "prometheus_repository" {
  type    = string
  default = "https://prometheus-community.github.io/helm-charts"
  description = "URL del repository Helm di Prometheus"
}

variable "prometheus_version" {
  type    = string
  default = "19.7.2"
  description = "Versione di Prometheus"
}

variable "grafana_chart" {
  type = string
  default = "grafana"
  description = "Nome del chart Helm di Grafana"
}

variable "grafana_name" {
  type = string
  description = "Nome della distribuzione di Grafana"
}

variable "grafana_repository" {
  type = string
  default = "https://grafana.github.io/helm-charts"
  description = "URL del repository Helm di Grafana"
}

variable "grafana_version" {
  type = string
  default = "6.52.1"
  description = "Versione di Grafana"
}