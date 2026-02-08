#!/bin/bash

STATE_FILE="$HOME/.cache/darkmode_state"
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
GTK3_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"

# Cores LS_COLORS para alto contraste no modo LIGHT
LS_COLORS_LIGHT="di=38;5;25;1:ln=38;5;53:so=32:pi=33:ex=38;5;22:bd=34;43:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;42:us=38;5;25:gr=38;5;25:da=38;5;240:im=38;5;53:*.jpg=38;5;53:*.png=38;5;53:*.svg=38;5;53:*.pdf=38;5;22:*.zip=38;5;88:*.ts=38;5;22"

apply_theme() {
    local mode=$1 # "on" (Dark) ou "off" (Light)
    local gtk_theme=$2
    local color_scheme=$3
    local alacritty_cfg=$4
    local ghostty_theme=$5

    if [ "$mode" = "on" ]; then
        # MODO DARK: Cores vibrantes do Ayu Dark
        fish_cmds="set -U theme_color_scheme dark;
                   set -U fish_color_command 5fffff;
                   set -U fish_color_param 87afff;
                   set -U fish_color_quote ffd787;
                   set -U fish_color_autosuggestion 767676;
                   set -e LS_COLORS"
    else
        # MODO LIGHT: Cores densas para fundo branco
        # Azul marinho para comandos, Ocre para strings, Cinza grafite para sugestões
        fish_cmds="set -U theme_color_scheme light;
                   set -U fish_color_command 0000D7 --bold;
                   set -U fish_color_param 005f87;
                   set -U fish_color_quote 875f00;
                   set -U fish_color_autosuggestion 585858;
                   set -Ux LS_COLORS '$LS_COLORS_LIGHT'"
    fi

    # 1. Sistema e GTK
    gsettings set org.gnome.desktop.interface color-scheme "$color_scheme"
    gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" "$GTK3_SETTINGS"

    # 2. Shell (Fish)
    fish -c "$fish_cmds"

    # 3. Terminais
    [ -f "$ALACRITTY_CONFIG" ] && sed -i "s/$([[ $mode == "on" ]] && echo "lite.toml" || echo "dark.toml")/$alacritty_cfg/" "$ALACRITTY_CONFIG"
    [ -f "$GHOSTTY_CONFIG" ] && sed -i "s/^theme = .*/theme = $ghostty_theme/" "$GHOSTTY_CONFIG"

    # 4. Sincronização Wayland
    dbus-send --session --type=method_call --dest=org.freedesktop.impl.portal.desktop.gtk \
        /org/freedesktop/portal/desktop org.freedesktop.impl.portal.Settings.ReadAll \
        array:string:"org.gnome.desktop.interface" >/dev/null 2>&1

    echo "$mode" >"$STATE_FILE"
    echo "Ambiente configurado para Modo $([[ $mode == "on" ]] && echo "DARK" || echo "LIGHT")"
}

case "$1" in
on) apply_theme "on" "Ayu-Dark" "prefer-dark" "dark.toml" "ayu_dark" ;;
off) apply_theme "off" "Ayu" "prefer-light" "lite.toml" "ayu_light" ;;
*) [ "$(cat "$STATE_FILE" 2>/dev/null)" = "on" ] && $0 off || $0 on ;;
esac
