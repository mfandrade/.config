#!/bin/sh

IMAGENAME="screenshot.$(date '+%F.%T' | tr ':' '-').png"
DIR="${XDG_PICTURES_DIR:-$HOME/dirs/Images}"
file_path="$DIR/$IMAGENAME"

symlink="$DIR/latest-screenshot.png"
sound="$HOME/dirs/Sounds/screenshot.wav"

grim "$file_path"

if test $? -eq 0; then
  ln -sf "$file_path" "$symlink"

  if test -f "$sound"; then
    aplay "$sound" &
  fi

  notify-send "Screenshot captured" "Image saved as $IMAGENAME" -i "camera"
fi
