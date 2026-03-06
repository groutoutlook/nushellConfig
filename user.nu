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

# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""

# INFO: All alias.
alias r = just
alias re = just -e
alias rr = just run
alias rrr = just rr
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

def --env cdsl [path: string = "."] {
  cd ($path | path expand)
}

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
alias cal = carl
alias serve = miniserve

def filter-uri [line: string, mode: string] {
    let match = ($line | parse --regex '\[(?<text>[^\]]+)\]\((?<url>[^)]+)\)')
    if ($match | is-empty) { return }
    
    let text = $match.text.0
    let url = ($match.url.0 | str trim)

    if not ($url | str starts-with "http") {
        # print (echo $"(ansi red)Somehow Invalid" | str join)
        return
    }

    let strip_pattern = "&dontwanttoplaytoomuchman"
    
    match $mode {
        "usual" => {
            if ($url | str contains $strip_pattern) {
                return
            } else {
                return $"($text)\n($url)"
            }
        }
        "rarely" => {
            if ($url | str contains $strip_pattern) {
                let cleaned_url = ($url | str replace $strip_pattern "")
                return $"($text)\n($cleaned_url)"
            } else {
                return
            }
        }
        "all" => {
            if ($url | str contains $strip_pattern) {
                let cleaned_url = ($url | str replace $strip_pattern "")
                return $"($text)\n($cleaned_url)"
            } else {
                return $"($text)\n($url)"
            }
        }
    }
}

def jmpv [
    --tail: list<int> = [100, 100]
    --head: list<int> = [1, 0]
    --strip-unplay: string = 'usual'
    --string-search: string = ""
    --video-option: string = "1"
    --mode: string = "normal"
] {
    let playlist_temp = ("~/mpv-playing.txt" | path expand)
    
    # Clean up old playlist
    if ($playlist_temp | path exists) {
        rm $playlist_temp
    }
    touch $playlist_temp

    if ($mode =~ "^n") {
        let playlist_file = ("~/hw/obs/note_entertainment/MusicJournal.md" | path expand)

        if ($string_search != "") {
            # In original PS, $stringSearch is [string], so -join ".*" results in the string itself.
            let final_pattern = $string_search
            
            # NOTE: The original script used $jtb["ms"] here as the search target. 
            # Substituted with $playlist_file due to missing context.
            rg $final_pattern $playlist_file -C3 | lines | each {|line| filter-uri $line $strip_unplay } | compact | save --append $playlist_temp
        } else {
            let content = (open $playlist_file | lines)
            
            # Head processing
            let head_count = $head.0
            let head_end = $head.1
            let head_part = ($content | first $head_count | first ($head_end + 1))

            # Tail processing
            let tail_count = $tail.0
            let tail_end = $tail.1
            let tail_part = ($content | last $tail_count | first ($tail_end + 1))

            ($head_part | append $tail_part) | each {|line| filter-uri $line $strip_unplay } | compact | save --append $playlist_temp
        }

        # Run mpv
        ^mpv $"--playlist=($playlist_temp)" --ytdl-format="bestvideo[height<=?1080]+bestaudio/best" --loop-playlist=1 $"--vid=($video_option)" --panscan=1.0 --sub-pos=20 --sub-color="1.0/0.2/0.2/0.5"

    } else if ($mode == "b") {
        let obs_path = (zoxide query obs | str trim)
        rg "spacing" -M 400 $obs_path | lines | each {|line| filter-uri $line $strip_unplay } | compact | save --append $playlist_temp
        
        ^mpv $"--playlist=($playlist_temp)" --ytdl-format="bestvideo[height<=?1080]+bestaudio/best" --loop-playlist=1 --vid=no --ytdl-raw-options="cookies-from-browser=firefox" --panscan=1.0 --sub-pos=20 --sub-color="1.0/0.2/0.2/0.5"
    }
}
