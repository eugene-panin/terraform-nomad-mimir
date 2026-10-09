mock_provider "nomad" {}

run "it_exposes_a_consul_service_with_the_default_config" {
  command = apply

  assert {
    condition     = output.service_name == "mimir" && output.http_port == 9009
    error_message = "Mimir is not exposed as the expected Consul service and port."
  }

  assert {
    condition     = strcontains(nomad_job.mimir.jobspec, "replication_factor: 1")
    error_message = "The monolithic single-node config was not written."
  }

  assert {
    condition     = !strcontains(nomad_job.mimir.jobspec, "host_network = \"public\"")
    error_message = "Metrics must never bind the public host network."
  }
}
