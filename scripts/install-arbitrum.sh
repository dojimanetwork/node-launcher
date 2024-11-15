#!/usr/bin/env bash

source ./scripts/core.sh

echo -e "=> Deploying a $boldgreen$TYPE$reset arbitrum stack on $boldgreen$NET$reset named $boldgreen$NAME$reset"
#confirm

case $NET in
  mainnet)
    EXTRA_ARGS="-f ./hermes-stack/chaosnet.yaml"
    ;;
  stagenet)
    EXTRA_ARGS="-f ./hermes-stack/stagenet.yaml"
    ;;
  testnet)
    EXTRA_ARGS="-f ./hermes-stack/testnet.yaml"
    ;;
  devnet)
    EXTRA_ARGS="-f ./hermes-stack/devnet.yaml"
    ;;
esac


create_namespace

get_node_name
get_l2_chain_id
get_l2_owner
# store priv keys
get_l2_deployer_priv_key_name
store_l2_owner_priv_key
get_l2_sequencer_priv_key_name
store_l2_sequencer_priv_key
get_redis_signing_key_name
store_redis_signing_key
get_hermes_gateway

# check to ensure required CRDs are created before deploying
if ! kubectl get crd servicemonitors.monitoring.coreos.com >/dev/null 2>&1; then
  echo "=> Required ServiceMonitor CRD not found - run 'make tools' before proceeding."
  exit 1
fi

deploy_arbitrum_rollup
