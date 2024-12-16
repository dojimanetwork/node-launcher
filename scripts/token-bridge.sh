#!/usr/bin/env bash

set -e

# create recover pod
echo "creating arbitrum token bridge contracts pod"

rollupAddr=$(kubectl exec -i -t arbitrum-5db69b8498-f6svk -c arbitrum-stack-sequencer -n arbitrum-rollup-1 -- cat /root/l2_config/deployment.json | jq -r '.rollup')

export ROLLUP_ADDR=$rollupAddr
envsubst '${ROLLUP_ADDR} ${DEPLOYER_PRIVKEY_NAME} ${PARENT_RPC} ${BS_EXTERNAL_IP} $SEQUENCER_PRIVKEY_NAME' < dependency_charts/token-bridge/deployment.yaml > dependency_charts/token-bridge/deployment_temp.yaml

kubectl apply -f dependency_charts/token-bridge/deployment_temp.yaml

# reset node state
echo "waiting for recover pod to be ready..."
kubectl wait --for=condition=complete pods/token-bride-contracts-arbitrum -n "${NAME}" --timeout=5m >/dev/null 2>&1

echo "=> ${boldgreen}Proceeding to clean up recovery pod and restart hermesnode${reset}"
confirm

echo "cleaning up recover pod"
kubectl -n "${NAME}" delete pod/restore-external-hermesnode
