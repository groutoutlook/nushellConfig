# Nushell config.

- This is my Nushell config.

[Focused workflow parity plan](PLAN.md): preserve the current setup and improve
selected daily PowerShell-like workflows on mobile incrementally. The roughly
70% target describes the intended familiar workflow, not a completed parity audit.

Documentation is registered with server-proxy as `nushell-config` through the
shared Doc-Styling-Zola catalog. Highway already links this checkout as `nushell`;
the optional docs import uses `~/hw/docs-engine` from the current Windows layout.

Use `just doc`, `just docs::check`, or `just docs::build` for guides, offline
validation and publication. See [maintenance](docs/MAINTENANCE.md) for ownership,
path overrides and the documentation-only publication scope. In Nushell, the
existing `r` wrapper forwards these commands; `r com` enables its completion.
