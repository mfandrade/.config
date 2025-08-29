# ~/.config/fish/config.fish

set -gx PAGER "bat -p"
set -gx MANPAGER 'sh -c "col -b | bat -l man -p"'
set -gx MANROFFOPT -c
set --path PATH $HOME/bin $PATH

if status is-interactive

    if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c)
    end

    set -x EZA_ICONS_AUTO yes
end
