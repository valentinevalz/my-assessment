provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Kubernetes deployment for the application
resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name = "app-deployment"
    labels = {
      app = "app"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "app"
      }
    }

    template {
      metadata {
        labels = {
          app = "app"
        }
      }

      spec {
        containers {
          name  = "app-container"
          image = "nginx:alpine" 
          ports {
            container_port = 80
          }
        }
      }
    }
  }
}


  # annotations for Prometheus monitoring
  spec {
    template {
      metadata {
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/path"   = "/metrics"
          "prometheus.io/port"   = "8080"
        }
      }
    }
  }


# Kubernetes service for the application
resource "kubernetes_service" "app_service" {
  metadata {
    name = "app-service"
    labels = {
      app = "app"
    }
  }
}

#Kubernetes ingress for HTTPS with Let's Encrypt
resource "kubernetes_ingress" "app_ingress" {
  metadata {
    name = "app-ingress"
  }

  #  TLS configuration for Let's Encrypt
  spec {
    tls {
      hosts = ["app_domain.com"] # app_domain name
      secret_name = "tls-secret"
    }

    # Specify ingress rules
    rule {
      host = "app_domain.com" # app_domain name
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.app_service.metadata[0].name
            service_port = 443
          }
        }
      }
    }
  }
}

#AWS security group for network security rules
resource "aws_security_group" "app_security_group" {
  name        = "app-security-group"
  description = "Security group for the app"

  # Ingress rule for HTTPS traffic (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to restrict outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define Let's Encrypt TLS certificate secret
resource "kubernetes_secret" "tls_secret" {
  metadata {
    name = "tls-secret"
  }

  data = {
    tls.crt = filebase64("/path/to/fullchain.pem") #file containing the full certificate chain 
    tls.key = filebase64("/path/to/privkey.pem")   #file containing the private key 
  }
}
