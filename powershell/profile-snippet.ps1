# Add these blocks to your PowerShell profile ($PROFILE).
#
# Windows PowerShell 5.1 profile path:
#   C:\Users\<you>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# PowerShell 7+ profile path:
#   C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
#
# Requires (see README): fastfetch, eza, oh-my-posh, and the JetBrainsMono Nerd Font.

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

# >>> oh-my-posh prompt >>>
# Styled, git-aware prompt using the bundled Catppuccin Mocha theme.
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$env:USERPROFILE\.config\oh-my-posh\catppuccin_mocha.omp.json" | Invoke-Expression
}
# <<< oh-my-posh <<<
