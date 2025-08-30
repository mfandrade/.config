# ~/.config/fish/config.fish

set -gx PAGER "bat -p"
set -gx MANPAGER 'sh -c "col -b | bat -l man -p"'
set -gx MANROFFOPT -c
set --path PATH $HOME/bin $PATH

if status is-interactive

    set -q SSH_AUTH_SOCK; or eval (ssh-agent -c)

    set -x EZA_ICONS_AUTO yes

    set -g theme_nerd_fonts yes
end
