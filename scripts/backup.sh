#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

if ! node_exists; then
  die "No existing HermesNode found, make sure this is the correct name"
fi

if [ "$SERVICE" = "" ]; then
  echo "=> Select a HermesNode service to backup"
  menu hermesnode hermesnode narada
  SERVICE=$MENU_SELECTED
fi

if ! kubectl -n "$NAME" get pvc "$SERVICE" >/dev/null 2>&1; then
  warn "Volume $SERVICE not found"
  echo
  exit 0
fi

make_backup "$SERVICE"
