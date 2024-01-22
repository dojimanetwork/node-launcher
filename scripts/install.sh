#!/usr/bin/env bash

source ./scripts/core.sh

SEED_TESTNET_ENODES=enode://5a9ebf001eda5ed9d703f2493663de2147f4fc8503983754714859993a470b7a3fd7600f5e8a76a442646ae79d53434a9cd8dc4228fea5efcca2ffadd49d1830@10.2.19.130:30303
SEED_TESTNET=10.2.2.218
SEED_TESTNET_EDDSA=10.2.239.237
SEED_STAGENET_ENODES=enode://5d136f07593a90d21141d126d97c476db72a83e0a3c20b3fd2f1623f24b513ca27ce160c4bedbd6b5daf1e8f3bcdaa12e7b3ce0eec67b7ff46d73abff7b622e2@10.2.139.123:30303
SEED_STAGENET=10.2.246.20
SEED_STAGENET_EDDSA=10.2.54.40

# sets type, name, net variables.
get_node_info

if node_exists; then
  warn "Found an existing HermesNode, make sure this is the node you want to update"
  #display_status
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
    SEED_EDDSA=$SEED_STAGENET_EDDSA
    ENODES=$SEED_STAGENET_ENODES
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
