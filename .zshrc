###########################
# REQUIRES: tmux, zsh-autosuggestions, zsh-syntax-highlighting
###########################
#
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=2000
WORDCHARS=${WORDCHARS//\/} 
setopt hist_expire_dups_first 
setopt hist_ignore_dups      
setopt hist_ignore_space     
setopt hist_verify            
setopt correct            
setopt interactivecomments 
setopt nonomatch          
setopt notify             
setopt numericglobsort     
setopt promptsubst         


autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false

if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
   . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PATH="$HOME/.cargo/bin:$PATH"


function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
# Corrige teclas de Backspace e Delete
bindkey "^?" backward-delete-char   # Backspace
bindkey "^H" backward-delete-char   # Backspace alternativa
bindkey "^[[3~" delete-char          # Delete


autoload -Uz vcs_info
precmd() { vcs_info }


PROMPT='%F{red}%n@%m%f:%F{blue}%~%f %F{magenta}${vcs_info_msg_0_}%f
%F{cyan}╰─➤ %f'
[ -z "$TMUX" ] && exec tmux

if command -v eza &> /dev/null; then
  alias ls="eza --icons=always"
else
  alias ls="ls"  # or whatever fallback you prefer
fi

alias tks="tmux kill-session -t"
alias dot='cd ~/Dotfiles'
alias bee='cd ~/beecrowd-c99'
alias agenda='(cd ~/Agenda && ./agenda && cd ~)'
alias script='cd ~/Scripts'


if [[ $- == *i* ]]; then
    cd ~/Agenda
    ./agenda
fi
cd ~


###### MEMENTO MORI ######

