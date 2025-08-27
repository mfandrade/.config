#!/bin/sh

DIR="$HOME/dirs/Inbox/"
LOG="$DIR/deleted-files.log"
0 * * * * echo "[$(date '+%F +%T')]:" >>~/Inbox/deleted.files.log && find ~/Inbox/* -mmin +180 -print -exec rm -rf {} + >>~/Inbox/deleted.files.log && echo >>~/Inbox/deleted.files.log
