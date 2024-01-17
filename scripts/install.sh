#!/usr/bin/env bash

source ./scripts/core.sh

SEED_TESTNET_ENODES=enode://7b13c0ec991d9fff9d84e2e96d271ee01597bcb5853792eb0f138f828ea5f5de109380d0eb17fc780c6806bbc93d97bd70fb0f5fcaa37bea7aec51be67041a95@10.2.20.202:30303
SEED_TESTNET=10.2.93.80
SEED_TESTNET_EDDSA=10.2.197.214
SEED_STAGENET=${SEED_STAGENET:="stagenet-seed.dojima.network"}
SEED_MAINNET=${SEED_MAINNET:=$(curl -s https://mainnet-seed.dojima.network/ | jq -r '. | join(",")' | sed "s/,/\\\,/g;s/|/,/g")}

# sets type, name, net variables.
get_node_info

if node_exists; then
  warn "Found an existing HermesNode, make sure this is the node you want to update"
  display_status
  echo
fi

echo -e "=> Deploying a $boldgreen$TYPE$reset HermesNode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
#confirm

if [ "$0" == "./scripts/update.sh" ] && snapshot_available; then
  make_snapshot "hermesnode"
  if [ "$TYPE" != "fullnode" ]; then
    make_snapshot "narada"
  fi
fi

case $NET in
  mainnet)
    SEED=$SEED_MAINNET
    EXTRA_ARGS="-f ./hermes-stack/chaosnet.yaml"
    ;;
  stagenet)
    SEED=$SEED_STAGENET
    EXTRA_ARGS="-f ./hermes-stack/stagenet.yaml"
    ;;
  testnet)
    SEED=$SEED_TESTNET
    SEED_EDDSA=$SEED_TESTNET_EDDSA
    ENODES=$SEED_TESTNET_ENODES
    EXTRA_ARGS="-f ./hermes-stack/testnet.yaml"
    ;;
  devnet)
#    SEED=$SEED_TESTNET
    EXTRA_ARGS="-f ./hermes-stack/devnet.yaml"
    ;;
esac

if [ -n "$HARDFORK_BLOCK_HEIGHT" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --set hermesnode.haltHeight=$HARDFORK_BLOCK_HEIGHT"
fi

create_namespace
if [ "$TYPE" != "daemons" ]; then
  create_password
  create_mnemonic
fi

# check to ensure required CRDs are created before deploying
if ! kubectl get crd servicemonitors.monitoring.coreos.com >/dev/null 2>&1; then
  echo "=> Required ServiceMonitor CRD not found - run 'make tools' before proceeding."
  exit 1
fi

case $TYPE in
  genesis)
    deploy_genesis
    ;;
  validator)
    deploy_validator
    ;;
  fullnode)
    deploy_fullnode
    ;;
  daemons)
    EXTRA_ARGS="$EXTRA_ARGS --set hermesnode.enabled=false"
    EXTRA_ARGS="$EXTRA_ARGS --set narada.enabled=false"
    EXTRA_ARGS="$EXTRA_ARGS --set gateway.enabled=false"
    deploy_validator
    ;;
esac
