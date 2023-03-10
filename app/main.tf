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

#definisco un servizio per esporre nel cluster la porta 8080 con cui l'applicazione comunica
resource "kubernetes_manifest" "devops-demo-serivce" {
  manifest = {
  "apiVersion" = "v1"
  "kind" = "Service"
  "metadata" = {
    "name" = "${var.deployment_name}-serivce"
    "namespace" = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  }
  "spec" = {
    "internalTrafficPolicy" = "Cluster"
    "ipFamilies" = [
      "IPv4",
    ]
    "ipFamilyPolicy" = "SingleStack"
    "ports" = [
      {
        "name" = "tcp8080"
        "port" = 8080
        "protocol" = "TCP"
        "targetPort" = 8080
      },
    ]
    "selector" = {
      "app" = "${var.deployment_name}-app"
    }
    "sessionAffinity" = "None"
    "type" = "ClusterIP"
  }
}
}

# definisco un servizio in configurazione load balancer
resource "kubernetes_manifest" "devops-demo-serivce-lb" {
  manifest = {
  "apiVersion" = "v1"
  "kind" = "Service"
  "metadata" = {
    "name" = "${var.deployment_name}-serivce-lb"
    "namespace" = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  }
  "spec" = {
    "ports" = [
      {
        "name" = "tcp8080"
        "port" = 8080
        "protocol" = "TCP"
        "targetPort" = 8080
      },
    ]
    "selector" = {
      "app" = "${var.deployment_name}-app"
    }
    "type" = "LoadBalancer"
  }
}
}

# definisco una configmap con le informazioni non "sensibili" per la connessione al database
# le informazioni vengono recuperate direttamente dall'output dello step precedente
# utilizzando un datasource sullo stato remoto di terraform
resource "kubernetes_manifest" "devops-demo-configmap" {
  manifest = {
  "apiVersion" = "v1"
  "data" = {
    "DB_HOST" = "${data.terraform_remote_state.postgres_state.outputs.distribution_name}-${data.terraform_remote_state.postgres_state.outputs.helm_chart}"
    "DB_NAME" = "${data.terraform_remote_state.postgres_state.outputs.postgres_db_name}"
    "DB_PORT" = "${data.terraform_remote_state.postgres_state.outputs.postgres_db_port}"
  }
  "kind" = "ConfigMap"
  "metadata" = {
    "name" = "${var.deployment_name}-configmap"
    "namespace" = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  }
}
}

# creo una secret in cui andare a salvare le credenziali per accedere al database
# le credenziali vengono recuperate direttamente dall'output dello step precedente
# utilizzando un datasource sullo stato remoto di terraform
resource "kubernetes_manifest" "devops-demo-secret" {
  manifest = {
  "apiVersion" = "v1"
  "data" = {
    "DB_PASS" = "${data.terraform_remote_state.postgres_state.outputs.postgres_db_password}"
    "DB_USER" = "${data.terraform_remote_state.postgres_state.outputs.postgres_db_user}"
  }
  "kind" = "Secret"
  "metadata" = {
    "name" = "${var.deployment_name}-secret"
    "namespace" = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  }
  "type" = "Opaque"
}
}

# definisco il deployment per l'applicazione di test
# facendo deployare 2 pod, in modo da garantire la resilienza del servizio
# specificando le risorse per i pod, in modo da non mandare in sofferenza altri 
# eventuali servizi deployati sul cluster ed evitando spreco di risorse e quindi 
# di danaro
resource "kubernetes_manifest" "devops-demo-app" {
  manifest = {
  "apiVersion" = "apps/v1"
  "kind" = "Deployment"
  "metadata" = {
    "labels" = {
      "app" = "${var.deployment_name}-app"
    }
    "name" = "${var.deployment_name}-app"
    "namespace" = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  }
  "spec" = {
    "progressDeadlineSeconds" = 600
    "replicas" = 2
    "revisionHistoryLimit" = 10
    "selector" = {
      "matchLabels" = {
        "app" = "${var.deployment_name}-app"
      }
    }
    "strategy" = {
      "rollingUpdate" = {
        "maxSurge" = 1
        "maxUnavailable" = 0
      }
      "type" = "RollingUpdate"
    }
    "template" = {
      "metadata" = {
        "annotations" = {
          "prometheus.io/path" = "/actuator/prometheus"
          "prometheus.io/port" = "8080"
          "prometheus.io/scrape" = "true"
        }
        "labels" = {
          "app" = "${var.deployment_name}-app"
        }
      }
      "spec" = {
        "affinity" = {}
        "containers" = [
          {
            "env" = [
              {
                "name" = "SPRING_PROFILES_ACTIVE"
                "value" = "${var.spring_profiles}"
              },
              {
                "name" = "DB_PASS"
                "valueFrom" = {
                  "secretKeyRef" = {
                    "key" = "DB_PASS"
                    "name" = "${var.deployment_name}-secret"
                    "optional" = false
                  }
                }
              },
              {
                "name" = "DB_USER"
                "valueFrom" = {
                  "secretKeyRef" = {
                    "key" = "DB_USER"
                    "name" = "${var.deployment_name}-secret"
                    "optional" = false
                  }
                }
              },
              {
                "name" = "DB_HOST"
                "valueFrom" = {
                  "configMapKeyRef" = {
                    "key" = "DB_HOST"
                    "name" = "${var.deployment_name}-configmap"
                    "optional" = false
                  }
                }
              },
              {
                "name" = "DB_PORT"
                "valueFrom" = {
                  "configMapKeyRef" = {
                    "key" = "DB_PORT"
                    "name" = "${var.deployment_name}-configmap"
                    "optional" = false
                  }
                }
              },
              {
                "name" = "DB_NAME"
                "valueFrom" = {
                  "configMapKeyRef" = {
                    "key" = "DB_NAME"
                    "name" = "${var.deployment_name}-configmap"
                    "optional" = false
                  }
                }
              },
            ]
            "image" = var.image
            "imagePullPolicy" = "Always"
            "livenessProbe" = {
              "failureThreshold" = 3
              "httpGet" = {
                "path" = "/actuator/health"
                "port" = 8080
                "scheme" = "HTTP"
              }
              "initialDelaySeconds" = 30
              "periodSeconds" = 20
              "successThreshold" = 1
              "timeoutSeconds" = 10
            }
            "name" = "appcomposer"
            "ports" = [
              {
                "containerPort" = 8080
                "name" = "tcp8080"
                "protocol" = "TCP"
              },
            ]
            "resources" = {
              "limits" = {
                "cpu" = var.resources_limit_cpu
                "memory" = var.resources_limit_memory
              }
              "requests" = {
                "cpu" = var.resources_reservation_cpu
                "memory" = var.resources_reservation_memory
              }
            }
            "securityContext" = {
              "allowPrivilegeEscalation" = false
              "capabilities" = {}
              "privileged" = false
              "readOnlyRootFilesystem" = false
              "runAsNonRoot" = true
              "runAsUser" = 1000
            }
            "stdin" = true
            "terminationMessagePath" = "/dev/termination-log"
            "terminationMessagePolicy" = "File"
            "tty" = true
          },
        ]
        "dnsPolicy" = "ClusterFirst"
        "restartPolicy" = "Always"
        "schedulerName" = "default-scheduler"
        "securityContext" = {}
        "terminationGracePeriodSeconds" = 30
      }
    }
  }
}
}

# definisco un ingress in http, sulla porta 80 mappato sul servizio 
# che permette di esporre l'applicazione 
resource "kubernetes_manifest" "devops-demo-ingress" {
  manifest = {
  "apiVersion" = "networking.k8s.io/v1"
  "kind" = "Ingress"
  "metadata" = {
    "annotations" = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
    "name" = "${var.deployment_name}-ingress"
    "namespace" = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  }
  "spec" = {
    "rules" = [
      {
        "http" = {
          "paths" = [
            {
              "backend" = {
                "service" = {
                  "name" = "${var.deployment_name}-serivce"
                  "port" = {
                    "number" = 8080
                  }
                }
              }
              "path" = "/"
              "pathType" = "Prefix"
            },
          ]
        }
      },
    ]
  }
}
}

# definisco una NetworkPolocy che permetta l'accesso al database dai soli pod
# con label "app: devops-test-app" e sulla sola porta 5432
resource "kubernetes_manifest" "devops-demo-networkpolicy" {
  manifest = {
  "apiVersion" = "networking.k8s.io/v1"
  "kind" = "NetworkPolicy"
  "metadata" = {
    "name" = "${var.deployment_name}-network-policy"
    "namespace" = "${data.terraform_remote_state.postgres_state.outputs.namespace}"
  }
  "spec" = {
    "egress" = [
      {},
    ]
    "ingress" = [
      {
        "from" = [
          {
            "podSelector" = {
              "matchLabels" = {
                "app" = "devops-test-app"
              }
            }
          },
        ]
        "ports" = [
          {
            "port" = 5432
            "protocol" = "TCP"
          },
        ]
      },
    ]
    "podSelector" = {
      "matchLabels" = {
        "app.kubernetes.io/name" = "postgresql"
      }
    }
    "policyTypes" = [
      "Ingress",
      "Egress",
    ]
  }
}

}