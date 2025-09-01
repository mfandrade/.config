#!/bin/bash
if pgrep -x swaynag >/dev/null; then
  exit
fi

CONFIRM=${3:-"Yes (click here)"}
swaynag -t warning -m "$1" -b "$CONFIRM" "$2"
