use ../completions/r.nu complete-just

def complete-r [buffer: string, place: record] {
    if not ($env.JUST_RECIPE_COMPLETION? | default false) { return [] }
    let text = ($buffer | str substring 0..<$place.cursor)
    complete-just ($text | split row ' ')
}

# Load metadata completion in the parent shell only when explicitly requested.
export def --env --wrapped main [...args: string@complete-r] {
    if $args == [com] {
        if not ($env.JUST_RECIPE_COMPLETION? | default false) {
            let previous = $env.config.completions.external.completer?
            $env.config.completions.external.completer = {|spans|
                if $spans.0 in [just r] { complete-just $spans } else if $previous != null { do $previous $spans } else { null }
            }
        }
        $env.JUST_RECIPE_COMPLETION = true
        print 'Just and current repository completion enabled for this shell.'
    } else {
        ^just ...$args
    }
}
