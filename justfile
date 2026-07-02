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

help:
    @just --list -f "{{home_directory()}}/justfile"

alias b := build
build: placeholder

# INFO: basic `run` recipe.
alias r := run
default_args := 'args here'
run args=default_args:
    @Write-Host {{default_args}} -ForegroundColor Red
    
alias fmt := format
format: 
    #!{{ shebang }}
    gci *.nu |%{echo $_.Name;topiary format $_}

alias ei:= edit-in-ide
[group('dev')]
edit-in-ide:
    code .
