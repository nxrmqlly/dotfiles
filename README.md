# dotfiles
Ritam's *nix dotfiles
> *"From bare TTYs, I forged my throne—hyprland my crown, configs my own."*

## Prerequisites
1. [GNU Stow](https://www.gnu.org/software/stow/)
2. [zsh](https://www.zsh.org/)

## Installation
1. Clone the repository
```
git clone https://github.com/nxrmqlly/dotfiles.git ~/dotfiles
```
2. Use stow to symlink the files
```
cd ~/dotfiles
stow .
```

## Desktop Stack
| Component           | Software            |
| :------------------ | :------------------ |
| WM                  | Hyprland            |
| Status Bar          | Waybar              |
| Notification Daemon | swaync              |
| Wallpaper Daemon    | swww-daemon         |
| Idle and Lock       | hypridle + hyprlock |
| Clipboard           | wl-paste + cliphist |
| Terminal Emulator   | Kitty               |
| App Launcher        | rofi                |
| Screenshots         | hyprshot            |
| Prompt              | oh-my-posh          |
| Shell               | zsh (w/ `zinit`)    |
