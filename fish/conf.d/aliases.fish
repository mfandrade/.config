abbr - cd -
abbr .. cd ..
abbr 1.. cd ..
abbr 2.. cd ../..
abbr 3.. cd ../../..
abbr 4.. cd ../../../..
abbr 5.. cd ../../../../..

# extremely common
abbr v nvim
abbr s session.sh
abbr p pass
abbr g git
abbr l eza -l
abbr ls eza
abbr la eza -a
abbr l1 eza -1
abbr t eza -T -L 2
abbr t1 eza -T -L 1
abbr t2 eza -T -L 2
abbr t3 eza -T -L 3
abbr t4 eza -T -L 4
abbr md mkdir
abbr rd rmdir
abbr c z
abbr cd z
abbr zi z -i
abbr cdi z -i
abbr lg lazygit
abbr ffp firefoxpwa
abbr fd fd -HI
abbr rg rg -.

# tree
abbr tree exa --tree --level=2 --git-ignore

# bat
abbr cat bat -n

# bak
function bak
    for file in $argv
        if test -e $file
            set -l target (string trim -r -c / $file).bak
            cp -ivR $file $target
        else
            echo "File '$file' does not exist" >/dev/stderr
            return 1
        end
    end
end

# ctrlc
function ctrlc
    set -l file $argv[1]

    if test -z "$file" -o ! -f "$file"
        echo "File not found" >/dev/stderr
        return 2
    end

    if file -bL --mime "$file" | grep -q 'binary$'
        echo "Binary file detected" >/dev/stderr
        return 1
    end

    if type -q fish_clipboard_copy
        fish_clipboard_copy <"$file"
    else
        echo "Function fish_clipboard_copy is not available" >/dev/stderr
        return 3
    end
end

# mkcd
function mkcd
    set -l folder $argv[1]

    if test -d "$folder" -o -f "$folder"
        # cannot create directory ‘dirs’: File exists
        echo "Cannot create directory '$folder': File exists" >/dev/stderr
        return 1
    end
    mkdir -p $folder
    cd $folder
end

# tmux
abbr tt tmux
abbr tl tmux list-sessions
abbr tt tmux new-session
abbr ta tmux attach-session

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
abbr asdfset 'asdf set --home'
function asdflatest
    set -l plugin $argv[1]
    set -l latest (test "$plugin" = java; and echo "latest:openjdk"; or echo latest)
    asdf install $plugin $latest && asdf set --home $plugin $latest
end
function asdfupgradeall
    argparse p/purge -- $argv
    or return
    # argparse defines a var called _flag_purge if it was passed
    set -l purge false
    if set -q _flag_purge
        echo "Also purging old versions"
        set purge true
    end
    for p in (asdf plugin list | grep -Ev 'lua|java|neovim|php')
        asdflatest $p
        if test "$purge" = true
            for v in (asdf list $p | grep -v '*')
                asdf uninstall $p $v
            end
        end
    end
end

# npm
abbr ni 'npm install'
abbr ns 'npm start'
abbr nt 'npm test'
abbr nrs 'npm run start'
abbr nrt 'npm run test'
abbr naf 'npm audit fix'

# apt
abbr sag 'sudo apt-get'
abbr sagu 'sudo apt-get update;'
abbr sagi 'sudo apt-get update && sudo apt install'
abbr sagr 'sudo apt-get remove --autoremove'
abbr sagp 'sudo apt-get purge --autoremove'
abbr safs 'sudo apt-file search'
