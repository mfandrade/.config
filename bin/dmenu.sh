#!/bin/bash

# Diretórios onde ficam arquivos .desktop padrão
DIRS=(
  /usr/share/applications
  /usr/local/share/applications
  "$HOME/.local/share/applications"
)

# Arquivo temporário para lista de apps e para mapear comando
APPS_LIST=$(mktemp)
APPS_MAP=$(mktemp)

# Percorre todos os .desktop e extrai Name e Exec
for dir in "${DIRS[@]}"; do
  [ -d "$dir" ] || continue
  find "$dir" -name '*.desktop' | while read -r desktop; do
    # Usa grep para pegar linhas Name e Exec, no padrão simples (só primeira ocorrência)
    NAME=$(grep -m1 '^Name=' "$desktop" | cut -d= -f2-)
    EXEC=$(grep -m1 '^Exec=' "$desktop" | cut -d= -f2- | sed 's/%.//g' | awk '{print $1}') # remove argumentos % e pega só o comando
    if [ -n "$NAME" ] && [ -n "$EXEC" ]; then
      echo "$NAME" >>"$APPS_LIST"
      echo "$NAME|$EXEC" >>"$APPS_MAP"
    fi
  done
done

# Escolhe com dmenu
CHOICE=$(cat "$APPS_LIST" | sort -u | dmenu -i -l 15 -fn 'UbuntuMono Nerd Font-12' -nb '#222222' -nf '#eeeeee' -sb '#d35400' -sf '#111111' -p "Aplicativos:")

rm "$APPS_LIST"

[ -z "$CHOICE" ] && exit 0

# Pega o comando pelo nome escolhido
CMD=$(grep "^$CHOICE|" "$APPS_MAP" | head -n1 | cut -d'|' -f2)

rm "$APPS_MAP"

# Executa o comando
[ -n "$CMD" ] && eval "$CMD" &
