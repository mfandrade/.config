#!/bin/sh

ID=$(firefoxpwa profile list | grep copilot.microsoft.com | grep -oE [A-Z0-9]{26})

if [ -z "$ID" ]; then
  echo 'ERROR: Microsoft Copilot not installed' >/dev/stderr
  return 1
fi

firefoxpwa site launch "$ID"
