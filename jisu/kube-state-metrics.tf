resource "kubernetes_cluster_role_binding" "kubestatemetrics_clusterRoleBinding" {
  metadata {
    name = "kube-state-metrics"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kube-state-metrics"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "kube-state-metrics"
    namespace = "kube-system"
  }
}


resource "kubernetes_cluster_role" "kubestatemetrics_clusterRole" {
  depends_on = [kubernetes_cluster_role_binding.kubestatemetrics_clusterRoleBinding]
  metadata {
    name = "kube-state-metrics"
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "secrets", "nodes", "pods", "services", "resourcequotas",
      "replicationcontrollers", "limitranges", "persistentvolumeclaims", "persistentvolumes",
      "namespaces", "endpoints"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["daemonsets", "deployments", "replicasets", "ingresses"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["statefulsets", "daemonsets", "deployments", "replicasets"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["tokenreviews"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["subjectaccessreviews"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["certificatesigningrequests"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["storageclasses", "volumeattachments"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["networkpolicies"]
    verbs      = ["list", "watch"]
  }
}
resource "kubernetes_service_account" "kube-state-metrics" {
  depends_on = [
  kubernetes_cluster_role.kubestatemetrics_clusterRole
  ]
  metadata {
    name = "kube-state-metrics"
    namespace = "kube-system"
  }
}


resource "kubernetes_deployment" "kube-state-metrics" {
  depends_on = [
  kubernetes_service_account.kube-state-metrics
  ]
  metadata {
    labels = {
      app = "kube-state-metrics"
    }
    name = "kube-state-metrics"
    namespace = "kube-system"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "kube-state-metrics"
      }
    }
    template {
      metadata {
        labels = {
          app = "kube-state-metrics"
        }
      }
      spec {
        container {
          image = "quay.io/coreos/kube-state-metrics:v1.8.0"
          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }
            initial_delay_seconds = 5
            timeout_seconds = 5
          }
          name  = "kube-state-metrics"
          port {
            container_port = 8080
            name = "http-metrics"
          }
          port {
            container_port = 8081
            name = "telemetry"
          }
          readiness_probe {
            http_get {
              path = "/"
              port = "8081"
            }
            initial_delay_seconds = 5
            timeout_seconds = 5
          }
        }
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        service_account_name = "kube-state-metrics"
      }
    }
  }
}

resource "kubernetes_service" "metrics-service" {
  depends_on = [
  kubernetes_deployment.kube-state-metrics
  ]
  metadata {
    name = "kube-state-metrics"
    namespace = "kube-system"
    labels = {
      app = "kube-state-metrics"
    }
  }
  spec {
    port {
      name = "http-metrics"
      port        = 9080
      target_port = "http-metrics"
    }
    port {
      name = "telemetry"
      port        = 9081
      target_port = "telemetry"
    }

    selector = {
      app = "kube-state-metrics"
    }
    type = "NodePort"
  }
}