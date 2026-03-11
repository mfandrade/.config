#!/usr/bin/env bash

# Script para encapsular o nvim com suporte para diferentes nomes (vi, vim, view)
# Autor: Marcelo F Andrade <mfandrade@gmail.com>
# Data: 20/03/2025

SCRIPT_NAME=$(basename "$0")
NVIM_BIN=$(command -v nvim)

# Verifica se o nvim está instalado
if [ -x "$NVIM_BIN" ]; then

  case "$SCRIPT_NAME" in
    view)
      exec "$NVIM_BIN" -R "$@"
      ;;
    vimdiff)
      exec "$NVIM_BIN" -d "$@"
      ;;
    vi | vim | gvim | nvim)
      exec "$NVIM_BIN" "$@"
      ;;
    *)
      printf "nvim.sh: cannot access '%s': No such file or directory\n" "$SCRIPT_NAME" >&2
      exec "$NVIM_BIN" "$@"
      ;;
  esac

fi
