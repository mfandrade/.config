# ~/.config/fish/config.fish

set -gx EDITOR vim
set --path PATH $HOME/bin $PATH

if status is-interactive
    set -gx PAGER 'bat -p'
    set -gx MANPAGER 'sh -c "col -b | bat -l man -p"'
    set -gx MANROFFOPT -c

    set -g theme_date_format "+%H:%M:%S.%3N"

    fish_vi_key_bindings
end
