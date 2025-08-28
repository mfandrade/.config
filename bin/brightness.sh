#!/bin/sh
# Script para mudar brilho e mostrar notificação

STEP="1%" # passo padrão
DIRECTION="$1"

if [ "$DIRECTION" = "up" ]; then
  brightnessctl set +$STEP >/dev/null
elif [ "$DIRECTION" = "down" ]; then
  brightnessctl set $STEP- >/dev/null
fi

PERCENT=$(brightnessctl g)
MAX=$(brightnessctl m)
LEVEL=$((PERCENT * 100 / MAX))

notify-send -h int:value:"$LEVEL" \
  -h string:x-canonical-private-synchronous:brightness \
  "Brightness: ${LEVEL}%"
