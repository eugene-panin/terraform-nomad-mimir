output "job_id" {
  description = "ID of the Mimir job in Nomad."
  value       = nomad_job.mimir.id
}

output "service_name" {
  description = "Consul service name clients reach Mimir by."
  value       = var.job_name
}

output "http_port" {
  description = "Port Mimir serves its HTTP API on; remote_write is /api/v1/push."
  value       = var.http_port
}

output "data_volume" {
  description = "Name of the dynamic host volume holding the metric blocks."
  value       = nomad_dynamic_host_volume.data.name
}
