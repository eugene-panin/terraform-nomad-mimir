variable "namespace" {
  description = "Nomad namespace the job runs in."
  type        = string
  default     = "default"
}

variable "job_name" {
  description = "Name of the Nomad job and the Consul service clients remote_write to and query."
  type        = string
  default     = "mimir"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,30}$", var.job_name))
    error_message = "job_name must be lowercase letters, digits and -, starting with a letter."
  }
}

variable "datacenters" {
  description = "Nomad datacenters the job may run in."
  type        = list(string)
  default     = ["*"]
}

variable "image" {
  description = "Mimir container image, pinned by a fixed tag or a digest."
  type        = string
  default     = "grafana/mimir:2.14.2"
}

variable "http_port" {
  description = "Port Mimir serves its HTTP API (remote_write at /api/v1/push, and queries) on, on the internal host network."
  type        = number
  default     = 9009
}

variable "grpc_port" {
  description = "Port Mimir serves gRPC on."
  type        = number
  default     = 9095
}

variable "retention_period" {
  description = "How long metric blocks are kept, as a Mimir duration (e.g. 15d). 0s keeps them forever."
  type        = string
  default     = "0s"
}

variable "config" {
  description = "Mimir configuration, verbatim. Null uses the built-in monolithic single-node filesystem config."
  type        = string
  default     = null
}

variable "internal_host_network" {
  description = "Nomad host network Mimir binds to. Never the public network: metrics are reachable only inside the platform."
  type        = string
  default     = "default"
}

variable "resources" {
  description = "CPU (MHz) and memory (MB) for the Mimir task: memory is what it reserves (sized to its use), memory_max how far it may grow (Nomad memory oversubscription)."
  type = object({
    cpu        = optional(number, 1000)
    memory     = optional(number, 256)
    memory_max = optional(number, 2048)
  })
  default = {}
  validation {
    condition     = var.resources.memory_max >= var.resources.memory
    error_message = "resources.memory_max must be at least resources.memory."
  }
}

variable "mesh" {
  description = <<-EOT
    The Consul service mesh. enabled puts Mimir behind an Envoy sidecar (transparent proxy):
    mesh services reach it as <job_name>.virtual.consul over mTLS, and only those in allow
    may (Consul intentions). The HTTP port stays reachable outside the mesh, for the
    platform's Alloy that pushes from the host and Consul's UI that reads; keep_open_ports
    are kept open as well. protocol is what Consul's L7 features see: http.
  EOT
  type = object({
    enabled         = optional(bool, false)
    allow           = optional(list(string), [])
    keep_open_ports = optional(list(number), [])
    protocol        = optional(string, "http")
  })
  default = {}
  validation {
    condition     = contains(["tcp", "http", "http2", "grpc"], var.mesh.protocol)
    error_message = "mesh.protocol must be tcp, http, http2 or grpc."
  }
}
