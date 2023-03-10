# provider per helm
provider "helm" {
  kubernetes {
    config_path = pathexpand(data.terraform_remote_state.postgres_state.outputs.kubeconfig_file_path)
  }
}

# provider per kubernetes
provider "kubernetes" {
  config_path = pathexpand(data.terraform_remote_state.postgres_state.outputs.kubeconfig_file_path)
}