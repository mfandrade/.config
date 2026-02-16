# ~/.config/fish/config.fish

set -gx PAGER 'bat -p'
set -gx MANPAGER 'sh -c "col -b | bat -l man -p"'
set -gx MANROFFOPT -c
set --path PATH $HOME/bin $PATH

if status is-interactive
    set -g theme_date_format "+%H:%M:%S.%3N"
    set -q SSH_AUTH_SOCK; or eval (ssh-agent -c)
    set -gx EZA_ICONS_AUTO yes
    set -gx RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/config"
    fish_vi_key_bindings

end
