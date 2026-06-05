# Add these blocks to your PowerShell profile ($PROFILE).
#
# Windows PowerShell 5.1 profile path:
#   C:\Users\<you>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# PowerShell 7+ profile path:
#   C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
#
# Requires (see README): fastfetch, eza, oh-my-posh, the JetBrainsMono Nerd Font,
# plus posh-git, PSFzf & fzf (for the git completion + fuzzy-search block below).

# >>> fastfetch >>>
# Show the fastfetch system banner on interactive terminal startup only.
# The guards keep it out of scripts / non-interactive sessions.
if ($Host.Name -eq 'ConsoleHost' -and
    -not ([Environment]::GetCommandLineArgs() -match '-NonInteractive|-Command|-EncodedCommand|-File')) {
    if (Get-Command fastfetch -ErrorAction SilentlyContinue) { fastfetch }
}
# <<< fastfetch <<<

# >>> eza (modern ls with icons) >>>
# Replaces ls and adds ll/la/lt, all with Nerd Font file-type icons + git status.
if (Get-Command eza -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    function ls { eza --icons --group-directories-first @args }
    function ll { eza -l --icons --git --group-directories-first @args }
    function la { eza -la --icons --git --group-directories-first @args }
    function lt { eza --tree --level=2 --icons @args }
}
# <<< eza <<<

# >>> git tab-completion + fuzzy search >>>
# Git-aware Tab completion (commands + branch names) and fuzzy finders.
# Keep this ABOVE the oh-my-posh block so oh-my-posh keeps owning the prompt.

# 1) Prefer the modern PSReadLine (Windows PowerShell 5.1 ships the in-box 2.0.0,
#    which lacks inline prediction; install a newer one with:
#      Install-Module PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck).
try {
    if ((Get-Module PSReadLine).Version -lt [version]'2.2.0') {
        Remove-Module PSReadLine -Force -ErrorAction SilentlyContinue
        Import-Module PSReadLine -MinimumVersion 2.2.0 -ErrorAction SilentlyContinue
    }
} catch {}

# 2) Line-editing UX: Tab opens a completion menu, gray inline autosuggest from
#    history, and Up/Down search history by what you've already typed.
try {  # inline autosuggest needs a VT-capable, non-redirected console
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView
} catch {}
Set-PSReadLineKeyHandler -Key Tab        -Function MenuComplete
Set-PSReadLineKeyHandler -Key RightArrow -Function ForwardChar            # accept suggestion
Set-PSReadLineKeyHandler -Key UpArrow    -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow  -Function HistorySearchForward

# 3) posh-git: `git che`<Tab> -> checkout, `git checkout feat`<Tab> -> branch names.
Import-Module posh-git -ErrorAction SilentlyContinue
if ($GitPromptSettings) { $GitPromptSettings.EnablePromptStatus = $false }  # oh-my-posh owns the prompt

# 4) PSFzf fuzzy finders (needs the fzf binary on PATH):
#      Ctrl+t = files   Ctrl+r = command history   Alt+c = cd into a dir
#      `git checkout **`<Tab> = fuzzy-pick a branch
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    Import-Module PSFzf -ErrorAction SilentlyContinue
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
                    -PSReadlineChordReverseHistory 'Ctrl+r' `
                    -PSReadlineChordSetLocation 'Alt+c'

    # `fbr` = fuzzy branch switch (local + remote, newest first).
    function fbr {
        $branch = git branch --all --sort=-committerdate |
            ForEach-Object { $_.TrimStart('* ').Trim() } |
            Where-Object { $_ -and $_ -notmatch '->' } |
            fzf --height 40% --reverse --prompt 'branch> '
        if ($branch) { git checkout ($branch -replace '^remotes/[^/]+/', '') }
    }
}
# <<< git tab-completion + fuzzy search <<<

# >>> oh-my-posh prompt >>>
# Styled, git-aware prompt using the bundled Catppuccin Mocha theme.
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$env:USERPROFILE\.config\oh-my-posh\catppuccin_mocha.omp.json" | Invoke-Expression
}
# <<< oh-my-posh <<<
