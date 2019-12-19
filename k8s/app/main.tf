provider "kubernetes" {
  host = "https://ea69ffef-1d9b-4908-906f-64afaf88d344.k8s.ondigitalocean.com"
  config_context_cluster   = "do-blr1-k8s-1-16-2-do-1-blr1-1576740650926"
  config_path = "./kube-conf.yaml"
}

resource "kubernetes_deployment" "nodejs-app" {
  metadata {
    name = "gatsby-task-app"
    labels = {
      selector = "gatsby-task-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        selector = "gatsby-task-app"
      }
    }

    template {
      metadata {
        labels = {
          selector = "gatsby-task-app"
        }
      }

      spec {
        container {
          image = "pntripathi9417/nodejs-app:v0.0.7"
          name  = "gatsby-task-app"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nodejs-app" {
  metadata {
    name = "gatsby-task-app"
  }
  spec {
    selector {
      selector = "gatsby-task-app"
    }
    port {
      port = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}