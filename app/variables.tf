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

variable "deployment_name" {
  type    = string
  default = "devops-test"
  description = "Nome del deployment, utilizzato per identificare tutti gli oggetti deployati"
}

variable "image" {
  type = string
  default = "ghcr.io/perceptolab/devops-demo-app:0.0.2"
  description = "Docker image da utilizzare nel deploy"
  
}

variable "spring_profiles" {
  type = string
  default = "prod,kubernetes,monitoring"  
  description = "Profili spring con cui eseguire l'applicazione"
}

variable "resources_limit_cpu" {
  type = string
  default = "1000m"
  description = "Valore di cpu limit per l'applicazione"
}


variable "resources_limit_memory" {
  type = string
  default = "1Gi"
  description = "Valore di memory limit per l'applicazione"
}

variable "resources_reservation_cpu" {
  type = string
  default = "250m"
  description = "Valore di cpu reservation per l'applicazione"
}

variable "resources_reservation_memory" {
  type = string
  default = "512Mi"
  description = "Valore di memory reservation per l'applicazione"
}