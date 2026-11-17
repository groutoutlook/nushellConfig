# Just's native completion backend; no recipes are executed.
export def main [spans: list<string>] {
    let words = ($spans | update 0 just)
    let result = (with-env {JUST_COMPLETE: fish} { ^just -- ...$words | complete })
    if $result.exit_code != 0 { return [] }
    $result.stdout | lines | where {|line| $line | is-not-empty } | each {|line|
        let parts = ($line | split row (char tab))
        {value: $parts.0, description: ($parts | get -o 1 | default $parts.0)}
    }
}
