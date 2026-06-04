# Add this block to your PowerShell profile ($PROFILE) to show the
# fastfetch system banner when you open an interactive terminal.
#
# Windows PowerShell 5.1 profile path:
#   C:\Users\<you>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# PowerShell 7+ profile path:
#   C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
#
# The guards make sure it only runs in an interactive console session, so it
# won't pollute scripts, CI, or tools that spawn PowerShell non-interactively.

# >>> fastfetch >>>
if ($Host.Name -eq 'ConsoleHost' -and
    -not ([Environment]::GetCommandLineArgs() -match '-NonInteractive|-Command|-EncodedCommand|-File')) {
    if (Get-Command fastfetch -ErrorAction SilentlyContinue) { fastfetch }
}
# <<< fastfetch <<<
