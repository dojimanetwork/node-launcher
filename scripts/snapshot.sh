#!/usr/bin/env bash

source ./scripts/core.sh

if ! snapshot_available; then
  warn "Snapshot not available in this cluster"
  echo
  exit 0
fi

get_node_info_short
if [ "$SERVICE" == "" ]; then
  echo "=> Select a HermesNode service to snapshot"
  menu hermesnode hermesnode narada narada-eddsa dojima-chain midgard binance-daemon bitcoin-daemon bitcoin-cash-daemon dogecoin-daemon ethereum-daemon litecoin-daemon gaia-daemon avalanche-daemon
  SERVICE=$MENU_SELECTED
fi

echo "=> Select cloud provider"
menu gcp gcp aws

case $MENU_SELECTED in
  gcp)
#    gcp_set_project
    make_gcp_snapshot "$SERVICE"
    ;;
  aws)
    make_snapshot "$SERVICE"
  ;;
esac

