+++
title = "Nushell config"
description = "Personal shell configuration, shared project workflows and a focused mobile parity plan."
sort_by = "weight"
template = "index.html"
+++

This checkout owns the Nushell startup files, command helpers and completion
modules. Keep the existing shell setup and improve selected daily workflows
incrementally.

[Highway](/sites/highway/) already links this checkout as `nushell`.
Doc-Styling-Zola supplies the common documentation recipes and theme;
[server-proxy](/sites/server-proxy/) owns publication, project discovery,
search and tasks. The site is `/sites/nushell-config/` on the shared gateway.

| Task                          | Command            |
| ----------------------------- | ------------------ |
| List this checkout's recipes  | `just --list`      |
| Open these guides             | `just doc`         |
| Check documentation offline   | `just docs::check` |
| Publish changed documentation | `just docs::build` |
| Find the registered checkout  | `just z nushell`   |
| List this repository's tasks  | `just td`          |

The Nushell `r` wrapper forwards ordinary arguments to Just. Its existing
`r com` branch enables Nushell completion in the current shell. Shared examples
using `r com | iex` are PowerShell instructions; use `r com` directly in Nushell.

Start with [maintenance and ownership](MAINTENANCE.md), the generated
[recipe reference](RECIPE_HELP.md), or the [shared documentation workflow](@/DOCUMENTATION.md).
