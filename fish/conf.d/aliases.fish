abbr cd- 'cd -'
abbr cd.. 'cd ..'
abbr 1.. 'cd ..'
abbr 2.. 'cd ../..'
abbr 3.. 'cd ../../..'
abbr 4.. 'cd ../../../..'
abbr 5.. 'cd ../../../../..'

# extremely common
abbr c code
abbr cls clear
abbr ls eza
abbr la 'eza -a'
abbr l 'eza -l'
abbr t 'eza -T'
abbr t2 'eza -T -L 2'
abbr t3 'eza -T -L 3'
abbr g git
abbr p pwd
abbr md mkdir
abbr rd rmdir
abbr cd z
abbr zz zi
abbr lg lazygit
abbr lr lazydocker
abbr ffp firefoxpwa
alias fd='fd -HI'
alias rg='rg -.'

# tree
alias tree='exa --tree --level=2 --git-ignore'

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
alias ta='tmux attach-session'
function tt
    set -l session (count $argv) >/dev/null; and set session $argv[1]; or set session default
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
abbr asdfpl 'asdf plugin list'
abbr asdfpla 'asdf plugin list all'
abbr asdfplag 'asdf plugin list all | grep'
abbr asdfpa 'asdf plugin add'
abbr asdfpr 'asdf plugin remove'
abbr asdfi 'asdf install'
abbr asdfl 'asdf list'
abbr asdfla 'asdf list all'
abbr asdlag 'asdf list all | grep'
abbr asdfu 'asdf uninstall'
function asdflatest
    set -l plugin $argv[1]
    set -l latest (test "$plugin" = java; and echo "latest:openjdk"; or echo latest)
    asdf install $plugin $latest && asdf set --home $plugin $latest
end
function asdfupgradeall
    for p in (asdf plugin list | grep -Ev 'lua|java')
        asdf install $p latest && asdf set --home $p latest
    end
end

abbr sudoapt 'sudo nala'
abbr sudoaptu 'sudo nala update;'
abbr sudoapti 'sudo nala update && sudo nala install'
abbr sudoaptr 'sudo nala remove --autoremove'
abbr sudoaptfs 'sudo apt-file search'
