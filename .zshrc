# ================================================ #
# =              Nxrmqlly's .zshrc               = #
# ================================================ #

# Only run if interactive shell
[[ $- != *i* ]] && return

# ====== Plugins ======
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


# ======= Terminal CLIs =======
eval "$(zoxide init zsh)"


# ======= Environment =======
export LANG=en_US.UTF-8
export PATH="$PATH:$HOME/.local/bin:$HOME/.spicetify:$HOME/bin:$HOME/.cargo/bin"

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


md5() { md5sum "$@" }
sha1() { sha1sum "$@" }
sha256() { sha256sum "$@" }
sha512() { sha512sum "$@" }

dirs() { find . -type d -name "$1" }

# find and grep alternatives
find-file() { find . -iname "*$1*" 2>/dev/null }
grepz() { grep "$1" "$2" }

# sed in-place replace
sedz() { sed -i "s/$1/$2/g" "$3" }

# git shortcuts
gcom() { git add . && git commit -m "$*" }
lazyg() { git add . && git commit -m "$*" && git push }

# utility
pubip() { curl ifconfig.me/all }
uptimez() { uptime -p }

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
  if [[ ! -f "$1" ]]; then echo "File '$1' not found."; return; fi
  curl -X POST https://mystb.in/api/paste \
       -H 'Content-Type: application/json' \
       -d "$(jq -n --arg content "$(cat "$1")" --arg filename "$(basename "$1")" '{expires:null, files:[{content:$content, filename:$filename}], password:null}')" \
       | jq -r '.id' | xargs -I {} echo "Paste URL: https://mystb.in/{}"
}

inspire() { curl -s https://www.affirmations.dev/ | jq -r '.affirmation' | cowsay }

# Default editor
export EDITOR=$(command -v nvim || command -v code || command -v nano || command -v vim || command -v vi || echo "nano")


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



# bun completions
[ -s "/home/ritam/.bun/_bun" ] && source "/home/ritam/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export LD_LIBRARY_PATH=/usr/lib/openssl-1.1:$LD_LIBRARY_PATH


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion

# ======= Oh My Posh (Prompt) =======
if command -v oh-my-posh >/dev/null; then
  eval "$(oh-my-posh init zsh --config ~/.cache/oh-my-posh/themes/pure.omp.json)"
fi