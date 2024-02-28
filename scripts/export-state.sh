#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

if ! node_exists; then
  die "No existing Hermesnode found, make sure this is the correct name"
fi

echo "=> Exporting Hermesnode chain state from $boldgreen$NAME$reset"
confirm

DATE=$(date +%s)
IMAGE=$(kubectl -n "$NAME" get deploy/hermesnode -o jsonpath='{$.spec.template.spec.containers[:1].image}')
SPEC=$(
  cat <<EOF
{
  "apiVersion": "v1",
  "spec": {
    "containers": [
      {
        "command": [
          "sh",
          "-c",
          "printf '\n\n' | hermesnode export --height 256000"
        ],
        "env": [
          {
            "name": "ETH_HOST",
            "value": "http://ethereum-daemon.hermes-devnet:9545"
          },
          {
            "name": "DOJIMA_RPC_URL",
            "value": "http://dojima-chain:8545"
          }
        ],
        "name": "export-state",
        "stdin": true,
        "tty": true,
        "image": "$IMAGE",
        "volumeMounts": [{"mountPath": "/root", "name":"data"}]
      }
    ],
    "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "hermesnode"}}]
  }
}
EOF
)

kubectl scale -n "$NAME" --replicas=0 deploy/hermesnode --timeout=5m
kubectl wait --for=delete pods -l app.kubernetes.io/name=hermesnode -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
kubectl run -n "$NAME" -it --quiet export-state --restart=Never --image="$IMAGE" --overrides="$SPEC" >"genesis.$DATE.json"
kubectl -n "$NAME" delete pod export-state --wait=false
kubectl scale -n "$NAME" --replicas=1 deploy/hermesnode --timeout=5m
