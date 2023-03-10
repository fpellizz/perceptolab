# datasource sullo stato remoto
# con questo datasource è possibile recuperare informazioni, in particolare output, 
# salvati da terraform in una iterazione precedente, in questo caso, 
# i dati sono quelli del deploy del database
data "terraform_remote_state" "postgres_state" {
    backend = "local" 
    config = {
    path = "../backend_local/postgres/terraform.tfstate"
  }
}

# Utiliizzando il provider helm, effettuo il deploy del chart di prometheus, 
# passandogli il file prometheus-values.yaml per la configurazione di tutti
# i parametri relativi al deploy
resource "helm_release" "prometheus" {
  chart      = var.prometheus_chart
  name       = var.prometheus_name
  namespace  = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  repository = var.prometheus_repository
  version    = var.prometheus_version

  values     = ["${file("./resources/prometheus-values.yaml")}"]

}

# Genero una password randomica di 8 caratteri che diverrà la password per grafana
resource "random_password" "grafana" {
  length = 8
}

# Creo una secret con le credenziali di accesso per Grafana
resource "kubernetes_secret" "grafana" {
  metadata {
    name      = "grafana"
    namespace  = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  }

  data = {
    admin-user     = "admin"
    admin-password = random_password.grafana.result
  }
}

# Utiliizzando il provider helm, effettuo il deploy del chart di grafana, 
# passandogli il file grafana-values.yaml per la configurazione di tutti
# i parametri relativi al deploy
resource "helm_release" "grafana" {
  chart      = var.grafana_chart
  name       = var.grafana_name
  repository = var.grafana_repository
  namespace  = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  version    = var.grafana_version

  set {
    name = "admin.existingSecret"
    value = kubernetes_secret.grafana.metadata[0].name
  }

  set {
    name = "admin.userKey"
    value = "admin-user"
  }

  set {
    name = "admin.passwordKey"
    value = "admin-password"
  }

  set {
    name = "admin.passwordKey"
    value = "admin-password"
  }

  set {
    name = "datasources.enabled"
    value = "true" 
  }

  values     = ["${file("./resources/grafana-values.yaml")}"]
}

# Creo una configmap contenente un dashboard per Grafana passando al 
# provider il file dashboard-devops-app.json ed inserendo la label "grafana_dashboard: dashboard"
# in modo tale da far capire al sidecar container del pod di grafana che questa configmap
# contiene un dashboard e che lo deve caricare.
resource "kubernetes_config_map" "application_dashboard" {
  metadata {
    name = "application-dashboard-configmap"
    namespace = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
    labels = {
      grafana_dashboard = "dashboard"
    }
  }

  data = {
    "nginx-dashboard.json" = "${file("${path.module}/resources/dashboard-devops-app.json")}"
  }
}