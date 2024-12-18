#!/usr/bin/env bash

set -e

# create recover pod
echo "creating arbitrum token bridge contracts pod"

rollupAddr=$(kubectl exec -it -c arbitrum-stack-sequencer deploy/arbitrum -n arbitrum-rollup-1 -- cat /root/l2_config/deployment.json | jq -r '.rollup')
deploymentJson=$(kubectl exec -it -c arbitrum-stack-sequencer deploy/arbitrum -n arbitrum-rollup-1 -- cat /root/l2_config/deployment.json)

export ROLLUP_ADDR=$rollupAddr
export DEPLOYMENT_JSON=$(echo $deploymentJson | jq -c .)
envsubst '${ROLLUP_ADDR} ${DEPLOYER_PRIVKEY_NAME} ${PARENT_RPC} ${BS_EXTERNAL_IP} $SEQUENCER_PRIVKEY_NAME $DEPLOYMENT_JSON' < dependency_charts/token-bridge/deployment.yaml > dependency_charts/token-bridge/deployment_temp.yaml

kubectl apply -f dependency_charts/token-bridge/deployment_temp.yaml

# reset node state
# on avg pod is taking 8m
echo "waiting for recover pod to be ready..."
kubectl wait --for=condition=ready pods/token-bridge-contracts-arbitrum -n "${NAME}" --timeout=10m

echo "=> ${boldgreen}Proceeding to clean up recovery pod and restart hermesnode${reset}"

## Check if the wait command was successful
#if [ $? -eq 0 ]; then
#  echo "cleaning up recover pod"
#  kubectl -n "${NAME}" delete pod/token-bridge-contracts-arbitrum
#else
#  echo "Pod $POD_NAME did not complete within the timeout period."
#fi


