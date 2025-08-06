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
    xsel --clipboard <"$file"
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
abbr g git
function load_git_shell_aliases
    set -l commands (git --list-cmds=main,nohelpers | sort)
    for cmd in $commands
        abbr g$cmd "git $cmd"
    end
end

# asdf
alias apadd='asdf plugin add'
alias aplist='asdf plugin list'
alias aplistall='asdf plugin list all'
alias alist='asdf list'
alias alistall='asdf list all'

function apsearch
    asdf plugin list all | grep $argv
end

function auninstall
    set -l plugin $argv[1]
    if test -n "$plugin"
        for v in (asdf list $plugin)
            asdf uninstall $plugin $v
        end
    end
end

function alatest
    set -l plugin $argv[1]
    set -l latest (test "$plugin" = java; and echo "latest:openjdk"; or echo latest)
    asdf install $plugin $latest && asdf set --home $plugin $latest
end

# nala
function sudo
    set -l cmd $argv[1]
    set -e argv[1]

    if test -n "$cmd"
        if string match -q "$cmd" apt apt-get
            command sudo nala $argv
        else
            command sudo $cmd $argv
        end
    else
        command sudo
    end
end
