output "app_container" {
  value = docker_container.app.name
}

output "flask_app_container" {
  value = docker_container.flask_app.name
}

output "db_container" {
  value = docker_container.db.name
}

output "network" {
  value = docker_network.app_net.name
}

