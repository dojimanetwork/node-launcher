#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

if ! node_exists; then
  die "No existing THORNode found, make sure this is the correct name"
fi

echo "=> Debugging THORNode in $boldgreen$NAME$reset"
confirm

IMAGE=$(kubectl -n "$NAME" get deploy/hermesnode -o jsonpath='{$.spec.template.spec.containers[:1].image}')
SPEC="
{
  \"apiVersion\": \"v1\",
  \"spec\": {
    \"containers\": [
      {
        \"command\": [
          \"sh\"
        ],
        \"name\": \"debug-hermesnode\",
        \"stdin\": true,
        \"tty\": true,
        \"image\": \"$IMAGE\",
        \"volumeMounts\": [{\"mountPath\": \"/root\", \"name\":\"data\"}]
      }
    ],
    \"volumes\": [{\"name\": \"data\", \"persistentVolumeClaim\": {\"claimName\": \"hermesnode\"}}]
  }
}"

kubectl scale -n "$NAME" --replicas=0 deploy/hermesnode --timeout=5m
kubectl wait --for=delete pods -l app.kubernetes.io/name=hermesnode -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
kubectl run -n "$NAME" -it --rm debug-hermesnode --restart=Never --image="$IMAGE" --overrides="$SPEC"
kubectl scale -n "$NAME" --replicas=1 deploy/hermesnode --timeout=5m
