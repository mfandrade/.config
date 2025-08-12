alias cd..='cd ..'
alias 1..='cd..'
alias 2..='cd ../..'
alias 3..='cd ../../..'
alias 4..='cd ../../../..'
alias 5..='cd ../../../../..'
alias 6..='cd ../../../../../..'

# extremely common
abbr l 'ls -lF'
abbr v vim
abbr g git
abbr cd z

# bat
alias cat='bat -n'

# bak
function bak
    if test (count $argv) -ne 1
        return 1
    end
    cp -iv $argv[1] "$argv[1].bak"
end

# ctrlc
function ctrlc
    set -l file $argv[1]
    if test -z "$file" -o ! -f "$file"
        return 2
    end
    if file -bL --mime "$file" | grep -q 'binary$'
        return 1
    end
    if type -q wl-copy
        wl-copy <"$file"
    else if type -q xsel
        xsel --clipboard <"$file"
    else
        return 3
    end
end

# tmux
alias tn='tmux new-session'
alias tl='tmux list-sessions'
function tt
    set -l session (count $argv) >/dev/null; and set session $argv[1]; or set session 0
    tmux has-session -t "$session" >/dev/null 2>&1
    and tmux attach-session -t "$session"
    or tmux new-session -s "$session"
end

# git
function load_git_shell_aliases
    set -l commands (git --list-cmds=main,nohelpers | sort)
    for cmd in $commands
        abbr g$cmd "git $cmd"
    end
end

# asdf
abbr apla 'asdf plugin list all'
abbr apa 'asdf plugin add'
abbr apl 'asdf plugin list'
abbr apr 'asdf plugin remove'
function alatest
    set -l plugin $argv[1]
    set -l latest (test "$plugin" = java; and echo "latest:openjdk"; or echo latest)
    asdf install $plugin $latest && asdf set --home $plugin $latest
end
abbr ai 'asdf install'
abbr al 'asdf list'
abbr ala 'asdf list all'
abbr au 'asdf uninstall'

abbr s sudo
abbr sa 'sudo apt-get'
abbr sau 'sudo apt-get update;'
abbr sai 'sudo apt-get install'
abbr saui 'sudo apt-get update && sudo apt-get install'
abbr sar 'sudo apt-get remove --autoremove'
