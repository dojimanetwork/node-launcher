#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

echo "Performing snapshot and backup for THORNode and Bifrost..."
confirm

if snapshot_available; then
  make_snapshot hermesnode
  make_snapshot narada
else
  warn "Snapshot not available in this cluster, performing backup only..."
  echo
fi

make_backup hermesnode
make_backup narada
