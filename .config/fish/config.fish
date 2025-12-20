set -gx FZF_CTRL_T_OPTS "
  --preview 'bat --style=numbers --color=always --line-range :500 {}' 
  --preview-window right:50%:wrap
"

alias ls="eza --icons always -1 -l -B --no-permissions -la"
alias vim="nvim"

set fish_greeting

function remove_path
    if set -l index (contains -i "$argv" $fish_user_paths)
        set -e fish_user_paths[$index]
        echo "Removed $argv from the path"
    end
end

zoxide init fish | source
fzf --fish | source
