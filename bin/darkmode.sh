#!/bin/sh

# Arquivo temporário para armazenar o estado do tema.
# Usamos um diretório de cache do usuário para boa prática.
STATE_FILE="$HOME/.cache/darkmode_state"

# Função para exibir o estado atual
show_status() {
  if [ -f "$STATE_FILE" ]; then
    current_state=$(cat "$STATE_FILE")
    if [ "$current_state" = "on" ]; then
      echo "Dark mode is ON"
    else
      echo "Dark mode is OFF"
    fi
  else
    # Se o arquivo não existir, consideramos que o modo padrão é claro.
    echo "Dark mode is OFF (default)"
  fi
}

# Função para ligar o modo escuro
set_dark() {
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  echo "on" >"$STATE_FILE"
  echo "Dark mode turned ON"
}

# Função para desligar o modo escuro
set_light() {
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  echo "off" >"$STATE_FILE"
  echo "Dark mode turned OFF"
}

# Lógica principal do script
case "$1" in
  on)
    set_dark
    ;;
  off)
    set_light
    ;;
  status)
    show_status
    ;;
  *)
    # Comportamento padrão: alternar
    if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "on" ]; then
      set_light
    else
      set_dark
    fi
    ;;
esac
