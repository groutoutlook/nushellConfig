def create_left_prompt [] {
  mut home = ""
  try { if $nu.os-info.name == "windows" { $home = $env.USERPROFILE } else { $home = $env.HOME } }
  let dir = (
    [
      ($env.PWD | str substring 0..($home | str length) | str replace $home "~")
      ($env.PWD | str substring ($home | str length)..)
    ] | str join
  )

  let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
  let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
  let path_segment = $"($path_color)($dir)"
  $path_segment | str replace --all (char path_sep) $"($separator_color)/($path_color)"
}

def create_right_prompt [] {
  # create a right prompt in magenta with green separators and am/pm underlined
  let time_segment = (
    [
      (ansi reset)
      (ansi magenta)
      (date now | format date '%Y/%m/%d %r')
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" | str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}"
  )

  let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {
    (
      [
        (ansi rb)
        ($env.LAST_EXIT_CODE)
      ] | str join
    )
  } else { "" }

  ([$last_exit_code (char space) $time_segment] | str join)
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
    to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
    to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
  }
}
$env.PAGER = "ov"
$env.VISUAL = "hx"
$env.EDITOR = $env.VISUAL
if (not ('XDG_CONFIG_HOME' in $env)) {
  $env.CLJ_CONFIG = $env.HOME + "/.clojure"
}
def setup-path [path: string, prepend = true] {
  if ((not ($path in $env.PATH)) and ($path | path exists)) {
    return ($env.PATH | split row (char esep) | if $prepend { prepend ($path) } else { append ($path) })
  }
  return $env.PATH
}
$env.PATH = (setup-path ($env.HOME + "/go/bin"))
$env.PATH = (setup-path ($env.HOME + "/.local/bin")) # pip install uses this
$env.PATH = (setup-path ($env.HOME + "/bin"))
$env.PATH = (setup-path ($env.HOME + "/.crc/bin/oc"))
$env.PATH = (setup-path ($env.HOME + "/.krew/bin"))
$env.PATH = (setup-path ($env.HOME + "/.cargo/bin"))
$env.RIPGREP_CONFIG_PATH = $env.HOME + "/.config/.ripgreprc"
$env.NUPM_HOME = ($env.HOME  | path join "nupm")
$env.PATH = (setup-path ($env.HOME | path join "scripts"))
$env.NU_LIB_DIRS = [
    ...
    ($env.NUPM_HOME | path join "modules")
]
$env.NU_PLUGIN_DIRS = [
  ($env.NUPM_HOME  | path join 'plugins') # add <nushell-config-dir>/plugins
]
