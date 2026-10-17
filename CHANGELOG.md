# Changelog

## v0.1.0

- Mimir as a monolithic single-node metric store on a Nomad platform: one job,
  metric blocks in a dynamic host volume the platform's backup copies by name
  (`meta.backup = "stop"`).
- A Consul service clients remote_write to (`/api/v1/push`) and query,
  health-checked on `/ready`, bound to the internal host network only.
- A built-in monolithic filesystem config with a configurable block retention; a
  full `config` overrides it.

## v0.1.1

- The task reserves 256 MB, sized to its use, and may grow to 2048 MB:
  `resources.memory_max` (Nomad memory oversubscription, which the platform
  turns on). It reserved more than it used before.

## v0.1.2

- `mesh`: Mimir can join the Consul service mesh — an Envoy sidecar with the
  transparent proxy, so mesh services (the dashboards) reach it as
  `<job_name>.virtual.consul` over mTLS as `mesh.allow` lets them
  (service-intentions). The HTTP port stays open for the platform's Alloy, which
  pushes from the host, and Consul's UI, which reads. Envoy's metrics are a
  `<job_name>-envoy` service tagged for Alloy.

## v0.1.3

- The mesh's config entries are written as Consul stores them (the empty
  blocks it fills into service-defaults; Type and Precedence on each intention
  source), so a plan no longer rewrites them on every apply.

## v0.1.4

- `service_tags` and `service_meta`: tags and meta of the Consul service
  clients reach it by, such as `damstack.provides=metrics@1`, `path=/prometheus`. None by
  default, so the job is as before.
