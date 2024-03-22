resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "namespace-monitoring"
    }

    labels = {
      mylabel = "namespace-monitoring"
    }

    name = "monitoring"
  }
}



resource "kubernetes_daemonset" "node-exporter" {
  depends_on = [
  kubernetes_namespace.monitoring
  ]

  metadata {
    name      = "node-exporter"
    namespace = "monitoring"
    labels = {
      k8s-app = "node-exporter"
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "node-exporter"
      }
    }
    template {
      metadata {
        labels = {
          k8s-app = "node-exporter"
        }
      }
      spec {
        container {
          image = "prom/node-exporter"
          name  = "node-exporter"
          port {
            container_port = 9100
            protocol = "TCP"
            name = "http"
          }

        }
      }
    }
  }
}


resource "kubernetes_service" "node-exporter-service" {
  depends_on = [
    kubernetes_daemonset.node-exporter
  ]
  metadata {
    name = "node-exporter"
    namespace = "kube-system"
    labels = {
      k8s-app = "node-exporter"
    }
  }
  spec {
    port {
      name = "http"
      port        = 9100
      protocol = "TCP"
    }
    type = "NodePort"
    selector = {
      k8s-app = "node-exporter"
    }
  }
}