variable "kube_config" {
  type    = string
  default = "~/.kube/config"
  #default = "./resources/config"
}

variable "prometheus_chart" {
  type    = string
  default = "prometheus"
}

variable "prometheus_name" {
  type    = string
  default = "prometheus"
}

variable "prometheus_repository" {
  type    = string
  default = "https://prometheus-community.github.io/helm-charts"
}

variable "prometheus_version" {
  type    = string
  default = "19.7.2"
}

variable "grafana_chart" {
  type = string
  default = "grafana"
}

variable "grafana_name" {
  type = string
  default = "grafana"
}

variable "grafana_repository" {
  type = string
  default = "https://grafana.github.io/helm-charts"
}

variable "grafana_version" {
  type = string
  default = "6.52.1"
}