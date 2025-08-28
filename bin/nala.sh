#!/usr/bin/env bash

# Script para encapsular o nala sendo chamado como apt e apt-get.
# Autor: Marcelo F Andrade <mfandrade@gmail.com>
# Data: 13/07/2025

SCRIPT_NAME=$(basename "$0")
NALA_BIN=$(command -v nala)

# Verifica se o nala está instalado
if [ -x "$NALA_BIN" ]; then

  case "$SCRIPT_NAME" in
  apt | apt-get)
    exec "$NALA_BIN" "$@"
    ;;
  *)
    printf "nala.sh: cannot access '%s': No such file or directory\n" "$SCRIPT_NAME" >&2
    exit 1
    ;;
  esac

fi
