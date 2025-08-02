#!/bin/sh

# Script POSIX-compatible para encapsular o nvim com suporte para diferentes nomes (vi, vim, view)
# Autor: Marcelo F Andrade <mfandrade@gmail.com>
# Data: 20/03/2025

SCRIPT_NAME=$(basename "$0")
NVIM_BIN=$(command -v nvim)

if [ -x "$NVIM_BIN" ]; then

  case "$SCRIPT_NAME" in
  view)
    exec "$NVIM_BIN" -R "$@"
    ;;
  vimdiff)
    exec "$NVIM_BIN" -d "$@"
    ;;
  vi | vim | nvim)
    exec "$NVIM_BIN" "$@"
    ;;
  *)
    printf "nvim.sh: cannot access '%s': No such file or directoryls: cannot access 'asdajshda': No such file or directory\n" "$SCRIPT_NAME" >&2
    exec "$NVIM_BIN" "$@"
    ;;
  esac

fi
