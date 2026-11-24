terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }

  backend "local" {}
}

provider "kubernetes" {
  config_path    = pathexpand("~/.kube/config")
  config_context = "kind-devops-lab"
}

variable "pr_number" {
  type = string
}

variable "image" {
  type = string
}

resource "kubernetes_namespace" "preview" {
  metadata {
    name = "pr-${var.pr_number}"

    labels = {
      purpose = "preview"
      pr      = var.pr_number
      owner   = "team-a"
      expires = "2026-12-01"
    }
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "myapp"
    namespace = kubernetes_namespace.preview.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "myapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "myapp"
        }
      }

      spec {
        container {
          name  = "myapp"
          image = var.image

          port {
            container_port = 3000
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3000
            }

            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "myapp"
    namespace = kubernetes_namespace.preview.metadata[0].name
  }

  spec {
    selector = {
      app = "myapp"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}