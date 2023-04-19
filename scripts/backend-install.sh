#!/usr/bin/env bash

source ./scripts/core.sh

get_backend_info

echo -e "=> Deploying a Backend apps on $boldgreen$BACKEND_NET$reset named $boldgreen$BACKEND_NAME$reset"
#confirm

create_backend_namespace

case $BACKEND_NET in
  testnet)
    EXTRA_ARGS="-f ./backend-apps/values.yaml"
    ;;
  stagenet)
    EXTRA_ARGS="-f ./backend-apps/valuesStage.yaml"

    ;;
  mainnet)
    EXTRA_ARGS="-f ./backend-apps/valuesProd.yaml"
    ;;
esac


deploy_backend