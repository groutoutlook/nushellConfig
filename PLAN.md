# Focused PowerShell workflow parity

Owner: this Nushell configuration checkout. Tracking: `nushell-config#83`.

The goal is a familiar daily shell on mobile, covering roughly 70% of the
PowerShell workflow by the user's estimate. That is a usability target, not a
measured percentage of commands already ported. Keep the current configuration
and improve a few high-value gaps at a time. A full repository reorganization,
machine migration, new shell framework or local server stack is outside scope.

The remote workstation also needs interactive ergonomics close to the laptop.
Server jobs can still use clean noninteractive shells independently of the
operator's normal shell. Mobile can use Nushell implementations of the same
workflow without reproducing PowerShell syntax or Windows-only integrations.

## Build on what is already here

Source inspection found these existing entry points; it does not establish
that every feature works on a phone or the current installed Nushell version.

| Workflow                 | Current source                                                             | Focused follow-up                                                                                        |
| ------------------------ | -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Navigation               | `user.nu`: `z`, `zi`, `cd`, `cd..`, `cdi`, `cd-`, `cdsl`                   | Compare directory changes, spaces and symlink handling with the familiar PowerShell behavior.            |
| File/search/view tools   | `user.nu`: `f`, `b`, `rgr`; `env.nu` editor/pager selection                | Keep useful short names; check available binaries and flags on each target.                              |
| Notes/journal search     | `user.nu`: `rgj`, `igj`, `j`                                               | Require a configured notes location only when invoked; do not make the whole vault a shell prerequisite. |
| Just workflows           | `commands/r.nu`; `user.nu`: `r`, `rr`, `rb`, `rt`, `rw`, `rfmt` and others | Preserve current work; check argument forwarding, caller directory and external exit status.             |
| Completion               | `completions/r.nu`, `completions/just.nu`                                  | Preserve opt-in `r com`; validate recipe/argument suggestions without executing recipes.                 |
| Editing/session helpers  | `user.nu`: `y`, `:v`, `:vs`, `nvim_session`                                | Check editor naming, configured paths and `~/hw` assumptions; keep optional app integrations optional.   |
| Prompt, keys and pickers | `config.nu`, `env.nu`, `starship.nu`, `fzf.nu`, `tv.nu`, `zoxide.nu`       | Preserve familiar bindings where the terminal supports them; check each integration separately.          |
| OS-specific helpers      | `os.nu`; `user.nu` aliases such as `expl`                                  | Select implementations for the actual platform and report unavailable features clearly.                  |

At inspection, `user.nu` was already modified and `commands/r.nu`,
`completions/r.nu`, and `completions/just.nu` were untracked work in progress.
This plan does not replace, reformat or claim authorship of those changes.
Do not publish `.env`, history or local credentials as part of the inventory.

## Small implementation batches

1. **Keep startup dependable.** Check the current Nushell version and launch
   path first. Inspect the unconditional `nc = netcat-openbsd` alias in `os.nu`
   and Windows-specific helpers before selecting target-specific behavior.
   Confirm which prompt/picker integrations are wanted on mobile and how
   missing optional tools should behave. Avoid moving files just for structure.
2. **Confirm a small daily command set.** Start with the observed navigation,
   file/search/view, editor and Just entry points above. Match command names
   and task outcomes where practical. Check spaces, empty results, errors,
   output shape and caller-directory changes for each selected workflow.
   Add missing helpers one family at a time; do not port the entire profile.
3. **Finish the existing completion work.** Review the current `r` wrapper and
   metadata completion together. Check opt-in activation, ordinary argument
   forwarding, correct checkout selection and failure behavior. Completion
   should inspect metadata rather than run build, deploy or service recipes.
4. **Add only needed control adapters.** For a selected `*ctl` command, keep
   mock fixtures and explicit remote execution separate. Match useful output
   fields and exit behavior. Add an adapter only when an actual workflow needs
   it; a generic mobile control framework is not required for this plan.

## Common behavior, platform-specific implementation

Prefer small edits to `user.nu`, `os.nu` and their existing modules. Keep
shared configuration on the same branch by default. Introduce a small target
or host-local override only when a real difference requires it.

The compatibility contract is command purpose, useful names/arguments, directory
effects, output and failures. The implementation can use Nushell-native data
and syntax. Desktop-only actions can be unavailable or have a deliberate
remote equivalent; do not claim a mock performed a real remote operation.

Do not require the entire MiscLang tree, server-proxy, PowerShell configuration
or Highway to be installed locally merely to provide shell ergonomics. Existing
helpers that currently depend on one of them should disclose that dependency;
remove or replace it only when working on that helper.

## Verify each change where it runs

- Use clean Nushell invocations to check the changed module/helper, with
  controlled fixtures and optional dependencies explicitly available/absent.
- Exercise navigation and file commands with spaces, symlinks and missing paths.
- Check external-tool exit codes and argument forwarding, not only printed text.
- Check completion/picker/key behavior interactively in the intended terminal.
- Verify mobile behavior on the actual Termux/device configuration; a Windows
  parse or mock test is not evidence that Android integration works.

For the first batch, success means the selected daily workflows are familiar
and dependable. Treat the approximate 70% goal as a frequency/importance-weighted
checklist with the user, not a requirement to count or port every PowerShell alias.

## Current status

Planning and source inspection only. No shell runtime files, packages, startup
behavior or mobile configuration were changed for this plan. No Termux/device
tests or full parity audit have been performed. Pick one implementation batch
when ready; do not combine this card with a wholesale migration effort.
