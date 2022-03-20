#! /bin/bash

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

#
# Global settings
#

export BROWSER="firefox"
export EDITOR="nvim"
export VISUAL="${EDITOR}"

#
# Set environment variables for programming languages
#

# go
command -v go >/dev/null 2>&1 && {
  export GOPATH="${HOME}/.go"
  export PATH="${PATH}:${GOPATH}/bin"
}

# ruby
command -v ruby >/dev/null 2>&1 && {
  PATH="$(ruby -e 'print Gem.user_dir')/bin:${PATH}"
  GEM_HOME=$(ruby -e 'print Gem.user_dir')
  export PATH
  export GEM_HOME
}

# npm
command -v npm >/dev/null 2>&1 && {
  export PATH="$PATH:$HOME/.npm/bin"
  export NPM_CONFIG_PREFIX=$HOME/.npm
}

# R
command -v R >/dev/null 2>&1 && {
  R_LIBS_USER="${HOME}/.R/$(R --version | sed -n "s/^R version \([0-9\.]*\) .*/\1/p")"
  export R_LIBS_USER
  alias R='R --no-save '
  if [ -d /usr/share/mathjax ]; then
    export RMARKDOWN_MATHJAX_PATH=/usr/share/mathjax
  fi
}

# beet autocompletion
command -v beet >/dev/null 2>&1 && {
  eval "$(beet completion)"
}

# custom scripts
export PATH=$PATH:$HOME/.scripts

# add local bin to path
export PATH=$PATH:$HOME/.local/bin


#
# Set bash aliases
#

alias vi='vim '
alias sudo='sudo '
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias happymake="make -j$(nproc) && sudo make install"

function superupgrade {
  sudo sh -c 'pacman -Syu && paccache -r && paccache -ruk0'
}

function megapurge {
  sudo sh -c 'yes | pacman -Scc' && \
    sudo journalctl --rotate && \
    sudo journalctl --vacuum-time=1s && \
    sudo pacdiff

  local pkg
  pkg=$(pacman -Qtdq | tr '\n' ' ') || true
  if [[ -n "${pkg}" ]]; then
    sudo sh -c "yes | pacman -Rs ${pkg}"
  fi
}

# list directory contents
alias ls='exa --color=auto'
alias sl='exa'
alias lsa='exa -lah'
alias l='exa -lah'
alias ll='exa -lh'
alias la='exa -lAh'
alias lt='exa -l --tree --level=3'

#
# Color terminal output
#

# color ls output based on filetype
eval "$(dircolors -b)"

# color the man pages
man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;38;5;74m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[38;5;246m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' \
  man "$@"
}

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
#[ -f "/home/revv/.ghcup/env" ] && source "/home/revv/.ghcup/env" # ghcup-env
export PATH=$PATH:$HOME/dev/go/bin
if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" && -z ${BASH_EXECUTION_STRING}  ]]
then
  exec fish
fi
#[ -f "/home/revv/.ghcup/env" ] && source "/home/revv/.ghcup/env" # ghcup-env
#[ -f "/home/revv/.ghcup/env" ] && source "/home/revv/.ghcup/env" # ghcup-env
[ -f "/home/revv/.ghcup/env" ] && source "/home/revv/.ghcup/env" # ghcup-env
