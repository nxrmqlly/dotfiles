# ================================================ #
# =              Nxrmqlly's .zshrc               = #
# ================================================ #

# Only run if interactive shell
[[ $- != *i* ]] && return


# ====== Plugins ======
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

autoload -Uz compinit && compinit

zinit cdreplay -q

# ===== Keybindings =====
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# ===== History =====

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# ======= Terminal CLIs =======
eval "$(zoxide init zsh)"
eval $(thefuck --alias fuck)

# ======= Environment =======
export LANG=en_US.UTF-8

# ======= Functions =======

explorer() {
  [[ -z "$1" ]] && set -- .
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open "$1"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "$1"
  else
    echo "Unsupported OS: $OSTYPE"
  fi
}


# utility
pubip() { curl ifconfig.me/all }


# Python venv activator
ipva() {
  if [[ -f .venv/bin/activate ]]; then
    echo "Activating .venv..."
    source .venv/bin/activate
  else
    echo "No virtual environment found."
  fi
}

mystbin() {
  if [[ ! -f "$1" ]]; then echo "File '$1' not found."J; return; fi
  curl -X POST https://mystb.in/api/paste \
       -H 'Content-Type: application/json' \
       -d "$(jq -n --arg content "$(cat "$1")" --arg filename "$(basename "$1")" '{expires:null, files:[{content:$content, filename:$filename}], password:null}')" \
       | jq -r '.id' | xargs -I {} echo "Paste URL: https://mystb.in/{}"
}

inspire() { curl -s https://www.affirmations.dev/ | jq -r '.affirmation' | cowsay }

# Default editor
export EDITOR=$(command -v nvim || command -v code || command -v nano || command -v vim || command -v vi || echo "nano")


# ======= Keybinds =======
bindkey "^[[3~" delete-char

# ======= Aliases =======
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'

alias ls='eza --all --color=always --group-directories-first --icons=always --no-user'
alias ll='eza --all --long --color=always --group-directories-first --icons=always --no-user'
alias tree='eza --all --tree --color=always --icons=always'

alias grep='grep --color=auto'
alias co='code'
alias g='git'
alias vim="$EDITOR"  # dynamically set

alias cat='bat --color=always --theme="Catppuccin Macchiato"'
alias fzfp='fzf --preview "cat {}"'

# "neofetch is no longer maintained :nerd: :point_up:"
alias neofetch=fastfetch

# yes.
alias fucking=sudo
alias please=sudo
alias pls=sudo

# pacman + fzf
alias paci="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias pacr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"

# bun completions
[ -s "/home/ritam/.bun/_bun" ] && source "/home/ritam/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"

export LD_LIBRARY_PATH=/usr/lib/openssl-1.1:$LD_LIBRARY_PATH

# ===== PATH =====
export PATH="$PATH:$HOME/.local/bin:$HOME/.spicetify:$HOME/bin:$HOME/.cargo/bin:$BUN_INSTALL/bin"


# ======= Oh My Posh (Prompt) =======
if command -v oh-my-posh >/dev/null; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/themes/ritam.omp.json)"
fi

pfetch
