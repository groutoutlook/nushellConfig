export-env {
  $env.STARSHIP_SHELL = "nu"; load-env {
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
      ^'starship' prompt --continuation
    )

    PROMPT_COMMAND: {||
      (
        ^'starship' prompt
        --cmd-duration $env.CMD_DURATION_MS
        $"--status=($env.LAST_EXIT_CODE)"
        --terminal-width (term size).columns
      )
    }

    config: (
      $env.config? | default {} | merge {
        render_right_prompt_on_last_line: true
      }
    )

    PROMPT_COMMAND_RIGHT: {||
      (
        ^'starship' prompt
        --right
        --cmd-duration $env.CMD_DURATION_MS
        $"--status=($env.LAST_EXIT_CODE)"
        --terminal-width (term size).columns
      )
    }
  }
}
