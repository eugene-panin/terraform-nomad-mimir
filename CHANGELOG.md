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
