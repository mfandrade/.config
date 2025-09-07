#!/bin/sh

MODE="${1:-screen}"
DIR="${XDG_PICTURES_DIR:-$HOME/dirs/Images}"
IMAGENAME="screenshot.$(date '+%F,%T,%N').png"
filepath="$DIR/$IMAGENAME"
symlink="$DIR/latest-screenshot.png"

test -d $(dirname "$filepath") || mkdir -p $(dirname "$filepath")

case "$MODE" in
  screen)
    grimshot --notify save screen "$filepath"
    ;;
  area)
    grimshot --notify savecopy anything "$filepath"
    ;;
  *)
    echo "$0: invalid mode '$MODE'. Use 'screen' or 'area'."
    exit 1
    ;;
esac

sound="$HOME/dirs/Sounds/screenshot.wav"

if test $? -eq 0; then
  ln -sf "$filepath" "$symlink"

  if test -f "$sound"; then
    aplay -q "$sound" &
  fi
fi
