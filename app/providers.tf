# provider per helm
provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}

# provider per kubernetes
provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}