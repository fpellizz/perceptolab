output "grafana_password" {
  value = resource.random_password.grafana
  description = "Password per accedere a grafana"
  sensitive = true
}