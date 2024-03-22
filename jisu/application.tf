provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_deployment" "spring-music" {
  metadata {
    name = "spring-music"
    namespace = "default"
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "spring-music"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "spring-music"
        }
      }
      spec {
        container {
          name  = "spring-music"
          image = "paastaccc/spring-music-sample:0.1"
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }
          resources {
            requests = {
              cpu = "500m"
              memory = "200Mi"
            }
          }


        }
      }
    }
  }
}

resource "kubernetes_service" "spring-music-service" {
  metadata {
    name = "spring-music-service"
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "spring-music"
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "NodePort"
  }
}



resource "kubernetes_ingress_v1" "alb" {
  metadata {
    name = "alb"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing",
      "alb.ingress.kubernetes.io/target-type" = "ip",
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path_type = "Prefix"
          backend {
            service {
              name = "spring-music-service"
              port {
                number = 8080
              }
            }
          }
          path = "/"
        }
      }
    }
  }
}


