# run command:
# terraform validate  # valdates configuration
# terraform init # gets providers
# [terraform plan # displays execution plan] - not mandatory step
# terraform apply [-auto-approve] # -auto-approve option to no need to confirm
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# App network
resource "docker_network" "app_net" {
  name = "app_network"
}

# App container (Django + Nginx host)
resource "docker_container" "app" {
  name  = "django_app"
  image = var.app_image
  # this prevents the container to exit immediately as pure ubuntu does not have any initial processes running
  # you can use also like this: command = ["sleep", "infinity"]
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
  networks_advanced {
    name = docker_network.app_net.name
  }

  # Nginx exposed to host
  ports {
    internal = 80
    external = 8080
  }
}

# Get PostgreSQL 16 image
resource "docker_image" "postgres" {
  name = "postgres:16"
}

# PostgreSQL container
resource "docker_container" "db" {
  name  = "postgres_db"
  image = docker_image.postgres.image_id

  restart = "unless-stopped"

  env = [
    "POSTGRES_PASSWORD=${var.pg_password}",
    "POSTGRES_USER=${var.pg_user}",
    "POSTGRES_DB=${var.pg_db}"
  ]

  ports {
    internal = 5432
    external = 5432
  }

  # Persistent data volume
  volumes {
    host_path      = "/var/lib/postgresql16-data"
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.app_net.name
  }
}

