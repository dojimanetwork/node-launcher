#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Setting HermesNode version"
kubectl exec -it -n "$NAME" -c hermesnode deploy/hermesnode -- /kube-scripts/retry.sh /kube-scripts/set-version.sh
sleep 5
echo HermesNode version updated
display_status
