#!/usr/bin/env bash

source ./scripts/core.sh

get_frontend_info

echo -e "=> Deploying a Frontend apps on $boldgreen$FRONTEND_NET$reset named $boldgreen$FRONTEND_NAME$reset"
#confirm

create_frontend_namespace

case $FRONTEND_NET in
  testnet)
    EXTRA_ARGS="-f ./frontend-apps/values.yaml"
    ;;
  stagenet)
    EXTRA_ARGS="-f ./frontend-apps/valuesStage.yaml"

    ;;
  mainnet)
    EXTRA_ARGS="-f ./frontend-apps/valuesProd.yaml"
    ;;
esac


deploy_frontend