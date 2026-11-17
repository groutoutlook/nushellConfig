+++
title = "Nushell Just commands"
description = "Local configuration recipes and inherited documentation, project discovery and task commands."
slug = "commands"
weight = 800
[extra]
category = "Reference"
+++

Just generates this reference from public recipe metadata. The existing
Nushell `r` wrapper forwards ordinary recipe arguments; `r com` is its own
opt-in completion action. Local `build` and `run` recipes remain explicitly
unimplemented templates; documentation uses `just docs::build`.

{{ recipes }}
