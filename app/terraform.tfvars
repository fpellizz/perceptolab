
deployment_name = "devops-test"
image = "ghcr.io/perceptolab/devops-demo-app:0.0.2"
resources_limit_cpu = "500m"
resources_limit_memory = "1Gi"
resources_reservation_cpu = "100m"
resources_reservation_memory = "512Mi"
spring_profiles = "prod,kubernetes,monitoring"