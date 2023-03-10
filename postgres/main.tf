# creo il namespace per il deploy dell'applicazione.
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

# utilizzando il provider per helm, viene deployata un'istanza di PostgresDB.
# Tutti i parametri sono definiti tramite le variabili di terraform. 
# Sono presenti i valori di default, tranne che per la password, per ragioni di sicurezza.
# Per questo è necessario andare a definire il file terraform.tfvars
resource "helm_release" "postgres" {
  chart      = var.helm_chart
  name       = var.helm_distribution_name
  namespace  = var.namespace
  repository = var.helm_repository

  set {
    name = "global.postgresql.auth.postgresPassword"
    value = var.db_password
  }

  set {
    name = "global.postgresql.service.ports.postgresql"
    value = var.db_port
  }

  set {
    name = "global.postgresql.auth.database"
    value = var.db_name
  }

  set {
    name = "global.postgresql.auth.username"
    value = var.db_user
  }
}