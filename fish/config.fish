# ~/.config/fish/config.fish

set -gx MANPAGER 'sh -c "col -b | bat -l man -p"'
set -gx MANROFFOPT -c
set --path PATH $HOME/bin $PATH

if status is-interactive
    # fish_vi_key_bindings
    clear
end

# aldlajsdhkajshkdaj hskdjask
