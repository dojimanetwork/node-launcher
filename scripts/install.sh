#!/usr/bin/env bash

source ./scripts/core.sh

SEED_TESTNET_ENODES=
SEED_TESTNET=4.213.194.232
SEED_TESTNET_EDDSA=4.213.194.232
SEED_STAGENET_ENODES=enode://941d64f04e7b9994b3d14c3c6f39908fe20d9a49b93d0219f69eedb1ad441f03de13acde7f9744adadf0bbd8e032fb39c0a68736aa70c38b3cac7dfb99ff6014@10.2.218.204:30303
SEED_STAGENET=10.2.120.227
SEED_STAGENET_EDDSA=10.2.3.248

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
