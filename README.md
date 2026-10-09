# terraform-nomad-mimir

Mimir on a Nomad platform that has Consul — such as
[hashi](https://github.com/eugene-panin/damstack-hashi). The
[damstack-mimir](https://github.com/eugene-panin/damstack-mimir) stack wires it.

A monolithic single-node metric store on local disk: one Nomad job, the metric
blocks in a host volume, exposed as a Consul service clients remote_write to
(`/api/v1/push`) and query. Prometheus-compatible, so a Prometheus dashboard
works against it unchanged. No multitenancy — it is reachable only inside the
platform. A collector (the platform's Alloy) remote_writes to it; Grafana
queries it.

## Inputs

| Name | Default | What |
| --- | --- | --- |
| `job_name` | `mimir` | Nomad job and Consul service name |
| `namespace` | `default` | Nomad namespace |
| `datacenters` | `["*"]` | Nomad datacenters |
| `image` | `grafana/mimir:2.14.2` | image, pinned |
| `http_port` | `9009` | HTTP API (`/api/v1/push`, queries) |
| `grpc_port` | `9095` | gRPC |
| `retention_period` | `0s` | how long blocks are kept; `0s` forever |
| `config` | built-in | full config to override the monolithic default |
| `internal_host_network` | `default` | host network it binds to |
| `resources` | `{1000, 2048}` | `{cpu, memory}` |

## Outputs

`job_id`, `service_name`, `http_port`, `data_volume`.

## Development

```sh
make lint
make module-tests
```
