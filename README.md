# 🪟✟ Windows Terminal — Glassmorphism Setup

<img width="2698" height="1463" alt="image" src="https://github.com/user-attachments/assets/33e60e97-dfba-44e7-8ea5-5e5e48d9b5e7" />

A fancy, iOS-style **glassmorphism** Windows Terminal config: frosted acrylic blur,
[Catppuccin Mocha](https://github.com/catppuccin/catppuccin) colors, the
[JetBrainsMono Nerd Font](https://www.nerdfonts.com/), a
[fastfetch](https://github.com/fastfetch-cli/fastfetch) system banner,
[eza](https://github.com/eza-community/eza) file icons, and an
[Oh My Posh](https://ohmyposh.dev/) git-aware prompt.

> Built and tested on **Windows 11 (25H2)** with **Windows Terminal 1.24** and
> **Windows PowerShell 5.1**.

---

## ✨ What you get

- **Frosted-glass panes** — translucent + acrylic blur (the "Catppuccin Glass" profile).
- **Catppuccin Mocha** color scheme (plus Tokyo Night, Dracula, Gruvbox & a custom
  "Loadex Night" scheme included but hidden — flip `"hidden": true` → `false` to use them).
- **JetBrainsMono Nerd Font** at medium weight — ligatures + powerline/icon glyphs.
- **fastfetch banner** with a Windows 11 logo and Nerd Font icons on every new tab.
- **eza** as `ls` — file-type icons, colors, and git status in directory listings
  (`ls`, `ll`, `la`, `lt` aliases).
- **Oh My Posh** prompt with the Catppuccin Mocha theme — git branch, folder & OS icons.
- **Git-aware Tab completion + fuzzy search** — [posh-git](https://github.com/dahlbyk/posh-git)
  completes git subcommands & branch names, [PSReadLine](https://github.com/PowerShell/PSReadLine)
  adds a Tab menu + gray inline autosuggest, and [PSFzf](https://github.com/kelleyma49/PSFzf) +
  [fzf](https://github.com/junegunn/fzf) give fuzzy history/file/branch pickers.
- **Frosted, translucent tab bar.**
- Quality-of-life: hidden scrollbar, airy padding, bar cursor, opens in `%USERPROFILE%`.

---

## 📦 Repo contents

| Path | What it is |
|---|---|
| `windows-terminal/settings.json` | The full Windows Terminal config. |
| `fastfetch/config.jsonc` | Themed fastfetch config (logo, modules, icon keys). |
| `oh-my-posh/catppuccin_mocha.omp.json` | Catppuccin Mocha prompt theme for Oh My Posh. |
| `powershell/profile-snippet.ps1` | Profile blocks: fastfetch banner + eza aliases + Oh My Posh init + git completion & fuzzy search. |

---

## 🚀 Install

### 1. Install the prerequisites (winget)

```powershell
winget install --id DEVCOM.JetBrainsMonoNerdFont --exact
winget install --id Fastfetch-cli.Fastfetch --exact
winget install --id eza-community.eza --exact
winget install --id JanDeDobbeleer.OhMyPosh --exact
winget install --id junegunn.fzf --exact            # fuzzy finder used by PSFzf
```

> The Nerd Font registers under the family name **`JetBrainsMono NF`** (Windows
> truncates the long Nerd Font name). That's the `face` value used in the config.

For the **git completion + fuzzy search** block, also install these PowerShell modules
(`CurrentUser` scope, no admin needed):

```powershell
Install-Module posh-git    -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module PSFzf       -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module PSReadLine  -Scope CurrentUser -Force -SkipPublisherCheck   # newer than the in-box 2.0.0
```

> If `fzf` isn't found after install, winget may have skipped its PATH shim (it needs
> Developer Mode / admin for symlinks). Add its package folder to your user PATH, e.g.
> `…\AppData\Local\Microsoft\WinGet\Packages\junegunn.fzf_*\`, then restart the terminal.

### 2. Drop the config files in place

```powershell
# Windows Terminal settings
copy windows-terminal\settings.json `
  "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# fastfetch config
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\fastfetch" | Out-Null
copy fastfetch\config.jsonc "$env:USERPROFILE\.config\fastfetch\config.jsonc"

# Oh My Posh theme
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\oh-my-posh" | Out-Null
copy oh-my-posh\catppuccin_mocha.omp.json "$env:USERPROFILE\.config\oh-my-posh\catppuccin_mocha.omp.json"
```

### 3. Wire fastfetch into your PowerShell profile

Append the contents of `powershell/profile-snippet.ps1` to your `$PROFILE`
(see paths inside that file).

### 4. ⚠️ Turn ON Windows "Transparency effects" — REQUIRED for the blur

The acrylic/frosted-glass blur **will not render** unless Windows transparency
effects are enabled. Without it, the terminal shows as a solid color.

- **Settings:** Settings → Personalization → Colors → **Transparency effects = On**, or
- **PowerShell:**
  ```powershell
  Set-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' `
    -Name EnableTransparency -Value 1 -Type DWord
  ```

### 5. Restart Windows Terminal

Open the **✟ Catppuccin Glass** profile (it's the default).

---

## 💡 Notes & gotchas

- **Blur only renders when the window is FOCUSED.** Windows makes acrylic windows
  solid when unfocused. The Glass profile sets an `unfocusedAppearance` so it stays
  plain-transparent (instead of solid) when you click away.
- **Screenshots:** `Win+Shift+S` steals focus → the terminal goes solid in the shot.
  Use `Win+PrtScn` or `PrtScn` to capture the blur while the terminal stays focused.
- **Glass needs something behind it.** A colorful wallpaper makes the frosted glass
  look great; over a plain/dark background it just looks dark gray.
- **Tuning transparency:** change `opacity` on the profile (0–100, lower = more
  see-through). Tab-bar transparency lives in the `themes` → `Glass` → `tabRow`
  `background` alpha (the last two hex digits, e.g. `…80` ≈ 50%).
- **On laptops**, Energy/Battery Saver can disable transparency effects automatically.

---

## 🎨 Switching themes on the fly

Hotkeys recolor the current tab (temporary):

| Keys | Scheme |
|---|---|
| `Ctrl+Alt+1` | Catppuccin Mocha |
| `Ctrl+Alt+2` | Tokyo Night |
| `Ctrl+Alt+3` | Dracula |
| `Ctrl+Alt+4` | Gruvbox Dark |
| `Ctrl+Alt+5` | Loadex Night |

---

## ⌨️ Git completion & fuzzy search

Once the modules + `fzf` are installed and the profile snippet is loaded:

| Action | How |
|---|---|
| Complete a git subcommand | `git che`<kbd>Tab</kbd> → `git checkout` |
| Complete a **branch name** | `git checkout fea`<kbd>Tab</kbd> → cycles matching branches |
| Pick from a completion **menu** | <kbd>Tab</kbd> opens a selectable menu (arrow keys) |
| **Fuzzy branch switch** | type `fbr` → pick a branch (local + remote, newest first) |
| Fuzzy branch picker inline | `git checkout **`<kbd>Tab</kbd> |
| Fuzzy **command history** | <kbd>Ctrl</kbd>+<kbd>R</kbd> |
| Fuzzy **file** insert | <kbd>Ctrl</kbd>+<kbd>T</kbd> |
| Fuzzy **cd** into a dir | <kbd>Alt</kbd>+<kbd>C</kbd> |
| Accept gray inline suggestion | <kbd>→</kbd> (RightArrow) |
| History search by prefix | <kbd>↑</kbd> / <kbd>↓</kbd> after typing |

> Prefer a dropdown list over gray inline text? Change `InlineView` → `ListView` in the
> `Set-PSReadLineOption -PredictionViewStyle` line.
