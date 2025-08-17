def --env --wrapped rgj [...rest: string] {
  # cd $'(zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
  rg -B1 -A4 ($rest | str join ".*") (zoxide query obs) -g "*Journal.md"
}

def --env --wrapped rgo [...rest: string] {
  rg -B1 -A4 ($rest | str join ".*") (zoxide query obs) -g !"*Journal.md"
}

def --env --wrapped gg [...rest: string] {
  let temp = "https://www.duckduckgo.com/?q=" + ($rest | str join "+")
  # xdg-open $temp
  start $temp
}

def --env --wrapped vrj [...rest: string] {
  # cd $'(zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
  ig ...$rest (zoxide query obs) -g "*Journal.md"
}
def --env "cd.." [levels: int = 1] {
    let path = (1..$levels | each { ".." } | str join "/")
    cd $path
}

def --env --wrapped toggle-edit-mode [...rest: string] {
  if $env.config.edit_mode != 'vi' {
    $env.config.edit_mode = 'vi'
  } else {
    $env.config.edit_mode = 'emacs'
  }
    echo $env.config.edit_mode
}

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
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
def nvim_session [input_string?: string] {
  # Default to "pw" if no input is provided
  let processed_string = if ($input_string | is-empty) { "nushell" } else { $session_map | get $input_string }

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
const ctrl_alt_x = {
  name: vi_mode_emacs
  modifier:  Control_Alt
  keycode: char_x
  mode: [emacs vi_normal vi_insert]
  event: [
    {
      send: executehostcommand
      cmd: "toggle-edit-mode"   
    }
  ]
}
const ctrl_g = { name: insert_gg_and_enter
  modifier: control
  keycode: char_s
  mode: [emacs vi_normal vi_insert]
  event: [{ edit: movetostart },{ edit: insertstring, value: "gg " }, { send: enter }]
}

def append_edit_if_j [] {
    let input = (commandline) 
    if ($input | str starts-with "j") {
        commandline edit -a " -4 --edit"
        commandline 
    } else {
        echo "not start with j"
    }
}
const ctrl_j = { name: append_edit_if_j
  modifier: control
  keycode: char_j
  mode: [emacs vi_normal vi_insert]
  # checkout : [feat: immediately accept by mrdgo · Pull Request #15092 · nushell/nushell](https://github.com/nushell/nushell/pull/15092)
  # event: [{send: ExecuteHostCommand, cmd: "append_edit_if_j" },{edit: MoveToEnd},{send: enter}]
  event: [{edit: MoveToEnd},{ edit: insertstring, value: " -4 --edit" },{send: enter}]
}
export-env {
  $env.config.keybindings = $env.config.keybindings | append [
    $ctrl_alt_x
    $ctrl_g
    $ctrl_j
  ]
}


# INFO: All alias.
alias r = just
alias re = just -e
alias rr = just run
alias rb = just build
alias rt = just test
alias rs = just seek
alias rw = just watch
alias rfmt = just fmt
alias rd = just deploy 
alias j = jrnl
alias z = __zoxide_z
alias zi = __zoxide_zi
alias cd = z
alias cdi = zi
alias cd- = cd -

alias md = mkdir
alias zo = zoxide query
alias zq = zoxide query
alias zoi = zoxide query -i
alias zqi = zoxide query -i
alias expl = explorer .
alias rgr = scooter
alias hx = helix
alias f = fd --hyperlink
alias ":v" = nvim
alias ":vs" = nvim_session
alias ":Vs" = nvim_session
alias ":q" = exit
alias ":Q" = exit
alias b = bat
alias bc = fend 
