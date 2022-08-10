#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Setting THORNode IP address"
kubectl exec -it -n "$NAME" deploy/hermesnode -- /kube-scripts/set-ip-address.sh "$(kubectl -n "$NAME" get configmap gateway-external-ip -o jsonpath="{.data.externalIP}")"
sleep 5
echo THORNode IP address updated
