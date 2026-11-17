shebang := if os() == 'windows' { 'pwsh.exe' } else { '/usr/bin/env pwsh' }
set shell := ["pwsh", "-c"]
set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]
set dotenv-load := true
set dotenv-filename	:= ".env"
set unstable
set fallback
set lists
# set dotenv-required := true
# INFO: if you want to edit the justfile use js -e.

# List recipes from the existing home Just entry point.
help:
    @just --list -f "{{home_directory()}}/justfile"

alias b := build
# Unimplemented application build; use docs::build for documentation.
build:
    @throw 'No application build is defined for this configuration checkout. Use just docs::build for documentation.'

# INFO: basic `run` recipe.
alias r := run
default_args := 'args here'
# Unimplemented run template; only print the sample default value.
run args=default_args:
    @Write-Host {{default_args}} -ForegroundColor Red
    
alias fmt := format
# Format root Nushell files with the existing Topiary command.
format: 
    #!{{ shebang }}
    gci *.nu |%{echo $_.Name;topiary format $_}

alias ei:= edit-in-ide
# Open this checkout in Visual Studio Code.
[group('dev')]
edit-in-ide:
    code .

# Shared docs, discovery and tasks through Highway's existing docs-engine link.
import? '../../../hw/docs-engine/just/docs.just'
