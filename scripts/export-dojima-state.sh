#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

if ! node_exists; then
  die "No existing Dojima chain found, make sure this is the correct name"
fi

echo "=> Exporting Dojima chain state from $boldgreen$NAME$reset"
#confirm

DATE=$(date +%s)
IMAGE=$(kubectl -n "$NAME" get deploy/dojima-chain -o jsonpath='{$.spec.template.spec.containers[:1].image}')
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
          "printf '\n\n' | dojimachain dump --datadir=/root/.dojimachain"
        ],
        "name": "export-dojima-state",
        "stdin": true,
        "tty": true,
        "image": "$IMAGE",
        "volumeMounts": [{"mountPath": "/root", "name":"data" },{"mountPath": "/scripts", "name": "scripts" }]
      }
    ],
    "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "dojima-chain"}}, {"name": "scripts", "configMap": {"name": "dojima-chain-scripts", "defaultMode": 511}}]
  }
}
EOF
)

kubectl scale -n "$NAME" --replicas=0 deploy/dojima-chain --timeout=5m
kubectl wait --for=delete pods -l app.kubernetes.io/name=dojima-chain -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
kubectl run -n "$NAME" -it --quiet export-state --restart=Never --image="$IMAGE" --overrides="$SPEC" >"dojima-genesis.$DATE.json"
kubectl -n "$NAME" delete pod export-state --wait=false
kubectl scale -n "$NAME" --replicas=1 deploy/dojima-chain --timeout=5m
