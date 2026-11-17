+++
title = "Maintain Nushell documentation"
description = "Connect through Highway, publish guides and preserve private shell state."
slug = "maintenance"
weight = 100
[extra]
category = "Start here"
+++

## Ownership and paths

The [Highway link registry](/sites/highway/links/) declares `nushell` as the
live roaming-AppData configuration and `docs-engine` as the shared documentation
checkout. Its established home entry point is `~/hw`.

This checkout's optional Just import and `docs/project.json` both use
`../../../hw/docs-engine`. From the current Windows roaming config directory,
that resolves to `~/hw/docs-engine`. The engine's `consumers.json` registers
the actual Nushell checkout as `nushell-config`; server-proxy reads that
catalog, so no duplicate gateway entry or per-project listener is needed.

After moving the configuration, update the one optional import and
`engine.checkout` for the target's actual directory layout. Set
`DOC_STYLING_ZOLA_ROOT` to override engine resolution at runtime and
`SERVER_PROXY_ROOT` if the gateway has moved. Just imports are literal paths;
an environment override does not replace a missing import. A Highway symlink
alone does not publish documentation.

## Check and publish

Use the installed Just wrapper, PowerShell 7 and Zola. These are documentation
tooling dependencies, not prerequisites for starting Nushell. Restore Highway's
`docs-engine` link before using the shared recipes. The import is optional so
the local recipes can still parse when the engine is absent.

```powershell
just --list
just docs::check
just docs::build
just doc --open=0
just z nushell --paths=1
```

Run these commands from this checkout. `docs::check` stages the shared site
under ignored `out/docs` and validates it offline. `docs::build` publishes
through server-proxy and refreshes the project's search index. The shared
gateway serves `/sites/nushell-config/`; the generated recipe guide is
`/sites/nushell-config/commands/`.

The older `b` / `build` entry point has no application build implementation
and reports that explicitly. The existing `run` recipe is a template that
prints a sample value. Use the docs recipes for documentation work.

## Content and private state

The manifest declares no source-search files. Publication includes the
authored guides, imported plan and shared guide, and generated recipe help.
It does not select `.env`, shell history, local credentials or shell runtime
files for source publication. Do not add private values to Markdown or recipes.

Keep startup and command/completion work separate from this documentation
connection. The parity plan remains tracked in `nushell-config#83`; the
server-proxy connection is tracked in `nushell-config#100`. Publishing the
plan does not establish Termux/device compatibility.

## Connection verification

Verified on November 17, 2026 with Just 1.59.0, Zola 0.23.6, Nushell 0.117.0
and PowerShell 7.7.0-rc.1 on this Windows workstation:

- `just --list` and `just docs::check` passed; Zola reported four pages,
  three sections and no orphan pages.
- `just docs::build` published `nushell-config`; gateway inventory reported
  one available, published owner with remote exposure disabled.
- The overview, maintenance, plan, commands and shared documentation pages
  returned HTTP 200 through loopback with the `docs.localhost` Host header.
  The PowerShell HTTP client did not resolve `docs.localhost` directly;
  this check made no DNS or hosts-file changes.
- Project search returned the parity plan and the `r docs::build` guide entry.
- `just z nushell --paths=1` and the existing `r` wrapper in a clean Nushell
  invocation returned this checkout. A temporary recipe fixture also listed
  local recipes with the optional docs-engine import missing.
- The shared source selector returned zero eligible files. No shell runtime
  files were edited or selected for source search by this connection.

The pre-existing missing `placeholder` dependency prevented every Just command
from parsing. The local build recipe now reports its unimplemented state
explicitly, and authored recipe comments allow generated help to validate.
No application build, package installation or mobile/device test was run.
