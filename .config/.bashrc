#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias l='ls -lah'
alias h='history'
alias shutdown='shutdown now'
alias v='vim'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

PS1='[\u@\h \W]\$ '
