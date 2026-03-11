#!/usr/bin/env bash

STATE_FILE="$HOME/.cache/darkmode_state"
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"
GTK3_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"

# Cores LS_COLORS para alto contraste no modo LIGHT
LS_COLORS_LIGHT="di=38;5;25;1:ln=38;5;53:so=32:pi=33:ex=38;5;22:bd=34;43:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;42:us=38;5;25:gr=38;5;25:da=38;5;240:im=38;5;53:*.jpg=38;5;53:*.png=38;5;53:*.svg=38;5;53:*.pdf=38;5;22:*.zip=38;5;88:*.ts=38;5;22"

apply_theme() {
    local mode=$1 # "on" (Dark) ou "off" (Light)
    local gtk_theme=$2
    local color_scheme=$3
    local alacritty_cfg=$4

    # 1. Sistema e GTK
    gsettings set org.gnome.desktop.interface color-scheme "$color_scheme"
    gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" "$GTK3_SETTINGS"

    # 2. Shell
    if [ "$mode" = "on" ]; then
        unset LS_COLORS
    else
        # No modo Light, removemos as cores customizadas e setamos LS_COLORS
        export LS_COLORS="$LS_COLORS_LIGHT"
    fi

    # 3. Terminais (Alacritty)
    local current_cfg=$([[ "$mode" == "on" ]] && echo "lite.toml" || echo "dark.toml")
    [ -f "$ALACRITTY_CONFIG" ] && sed -i "s/$current_cfg/$alacritty_cfg/" "$ALACRITTY_CONFIG"

    # 4. Sincronização Wayland
    dbus-send --session --type=method_call --dest=org.freedesktop.impl.portal.desktop.gtk \
        /org/freedesktop/portal/desktop org.freedesktop.impl.portal.Settings.ReadAll \
        array:string:"org.gnome.desktop.interface" >/dev/null 2>&1

    echo "$mode" >"$STATE_FILE"
    echo "Dark mode is now ${mode^^}"
}

case "$1" in
on)
    apply_theme "on" "Ayu-Dark" "prefer-dark" "dark.toml"
    ;;
off)
    apply_theme "off" "Ayu" "prefer-light" "lite.toml"
    ;;
*)
    if [ "$(cat "$STATE_FILE" 2>/dev/null)" = "on" ]; then
        $0 off
    else
        $0 on
    fi
    ;;
esac
