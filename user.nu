def --env --wrapped rgj [...rest: string] {
  # cd $'(zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
  rg -C3 ...$rest (zq obs) -g "*Journal.md"
}

def --env --wrapped rgo [...rest: string] {
  rg -C3 ...$rest (zq obs) -g !"*Journal.md"
}

def --env --wrapped gg [...rest: string] {
  let temp = "https://www.duckduckgo.com/?q=" + ($rest | str join "+")
  xdg-open $temp
}

# INFO: Quick session management for NuShell + nvim. 
# Define session map as a record
let session_map = {
  pw: "pwsh"
  nv: "nvim"
  nu: "nushell"
  m: "mouse"
  ob: "obsidian"
  es: "espanso"
  vk: "vulkan-samples"
  wts: "wt_shader"
}

# Define the :vs command
def ":vs" [$input_string?: string] {
  # Default to "pw" if no input is provided
  let processed_string = if ($input_string | is-empty) { "nushell" } else { $session_map | get -i $input_string }

  if ($processed_string | is-empty) {
    print --stderr $"\e[33mWhat do you want?\e[0m"
    :v .
  } else {
    if ($env.NVIM_APPNAME? | is-empty) {
      nvim -c $"lua require\('resession'\).load \"($processed_string)\""
    } else {
      # Convert path to use // separators
      let editor_path = ($"($env.HOME)//hw//($processed_string)" | str replace --all '[\\/]+' '//')
      ^($env.EDITOR?) $editor_path
    }
  }
}

# INFO: All alias.
alias r = just
alias rr = just run
alias rb = just build
alias re = just -e
alias j = jrnl
alias z = __zoxide_z
alias zi = __zoxide_zi
alias cd = z
alias cdi = zi
alias cd- = cd -
alias zo = zoxide query
alias zq = zoxide query
alias zoi = zoxide query -i
alias zqi = zoxide query -i
alias expl = explorer .
alias :v = nvim
alias :Vs = :vs
