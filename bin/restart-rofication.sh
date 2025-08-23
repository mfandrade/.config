#!/bin/bash

# Mata o daemon
pkill -f rofication-daemon

# Aguarda o socket ser removido
SOCKET="/tmp/rofication-daemon"
TIMEOUT=5
while [ -e "$SOCKET" ] && [ $TIMEOUT -gt 0 ]; do
  sleep 1
  TIMEOUT=$((TIMEOUT - 1))
done

# Reinicia o daemon
nohup rofication-daemon >/dev/null 2>&1 &
