use just.nu

export def complete-just [spans: list<string>] {
    mut root = $env.PWD
    loop {
        if ([justfile .justfile] | any {|file| $root | path join $file | path exists }) { break }
        let parent = ($root | path dirname)
        if $parent == $root { return (just $spans) }
        $root = $parent
    }
    let hints = ($root | path join completions r.nu)
    let explicit_target = ($spans | any {|word| $word =~ '^(-f|-d|--justfile|--working-directory)(=|$)' })
    if not $explicit_target and ($hints | path exists) {
        let result = (^$nu.current-exe --no-config-file $hints ($spans | to json --raw) | complete)
        if $result.exit_code == 0 {
            let matches = (try { $result.stdout | from json } catch { [] })
            if ($matches | is-not-empty) { return $matches }
        }
    }
    just $spans
}
