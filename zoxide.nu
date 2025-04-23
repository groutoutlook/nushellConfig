export-env {
  $env.config = (
    $env.config?
    | default {}
    | upsert hooks { default {} }
    | upsert hooks.env_change { default {} }
    | upsert hooks.env_change.PWD { default [] }
  )
  let __zoxide_hooked = (
    $env.config.hooks.env_change.PWD | any { try { get __zoxide_hook } catch { false } }
  )
  if not $__zoxide_hooked {
    $env.config.hooks.env_change.PWD = (
      $env.config.hooks.env_change.PWD | append {
        __zoxide_hook: true
        code: {|_, dir| zoxide add -- $dir }
      }
    )
  }
}

# Jump to a directory using only keywords.
def --env --wrapped __zoxide_z [...rest: string] {
  let path = match $rest {
    [] => { '~' }
    ['-'] => { '-' }
    [$arg] if ($arg | path type) == 'dir' => { $arg }
    _ => {
      zoxide query --exclude $env.PWD -- ...$rest | str trim -r -c "\n"
    }
  }
  cd $path
}

def --env --wrapped __zoxide_zi [...rest: string] {
  cd $'(zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
}
