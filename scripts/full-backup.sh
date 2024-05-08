#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

echo "Performing snapshot and backup for Hermesnode and Narada..."
confirm

if snapshot_available; then
  make_snapshot hermesnode
  make_snapshot narada
  make_snapshot narada-eddsa
  make_snapshot dojimachain
else
  warn "Snapshot not available in this cluster, performing backup only..."
  echo
fi

make_backup hermesnode
make_backup narada
make_backup narada-eddsa
make_backup dojimachain
