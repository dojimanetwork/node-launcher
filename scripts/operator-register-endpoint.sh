#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Register operator endpoint"
kubectl exec -it -n "$NAME" -c hermesnode deploy/hermesnode -- /kube-scripts/retry.sh /kube-scripts/operator-register-endpoint.sh
sleep 5
echo Operator endpoint registered
display_status
