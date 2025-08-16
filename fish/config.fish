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
    set -g theme_newline_cursor yes
    set -g theme_date_format "+%s"
    set -g theme_display_git_untracked no
    set -g theme_show_exit_status no
    # fish_vi_key_bindings; set -g theme_display_vi yes

    if test -z "$TMUX"; and type -q tmux
        tmux attach -t default 2>/dev/null; or tmux new -s default
    end
end
