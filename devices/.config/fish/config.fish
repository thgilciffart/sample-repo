set -gx FZF_CTRL_T_OPTS "
  --preview 'bat --style=numbers --color=always --line-range :500 {}' 
  --preview-window right:50%:wrap
"

alias ls="eza --icons always -1"
alias vim="nvim"

set fish_greeting

zoxide init fish | source
fzf --fish | source
