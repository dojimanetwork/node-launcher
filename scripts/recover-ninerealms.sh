#!/usr/bin/env bash

set -e

source ./scripts/core.sh

echo "Nine Realms only provides mainnet snapshots. Continue?"
confirm
NET="mainnet"

get_node_info_short

if ! node_exists; then
  die "No existing Hermesnode found, make sure this is the correct name"
fi

HEIGHTS=$(
  curl -s 'https://storage.googleapis.com/storage/v1/b/public-snapshots-ninerealms/o?delimiter=%2F&prefix=hermesnode/' |
    jq -r '.prefixes | map(match("hermesnode/([0-9]+)/").captures[0].string) | map(tonumber) | sort | reverse | map(tostring) | join(" ")'
)
LATEST_HEIGHT=$(echo "$HEIGHTS" | awk '{print $1}')
echo "=> Select block height to recover"
# shellcheck disable=SC2068
menu "$LATEST_HEIGHT" ${HEIGHTS[@]}
HEIGHT=$MENU_SELECTED

echo "=> Recovering height Nine Realms snapshot at height $HEIGHT in Hermesnode in $boldgreen$NAME$reset"
confirm

# stop hermesnode
echo "stopping hermesnode..."
kubectl scale -n "$NAME" --replicas=0 deploy/hermesnode --timeout=5m
kubectl wait --for=delete pods -l app.kubernetes.io/name=hermesnode -n "$NAME" --timeout=5m >/dev/null 2>&1 || true

# create recover pod
echo "creating recover pod"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: recover-hermesnode
  namespace: $NAME
spec:
  containers:
  - name: recover
    image: google/cloud-sdk@sha256:f94bacf262ad8f5e7173cea2db3d969c43b938a036e3c6294036c3d96261f2f4
    command:
      - tail
      - -f
      - /dev/null
    volumeMounts:
    - mountPath: /root
      name: data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: hermesnode
EOF

# reset node state
echo "waiting for recover pod to be ready..."
kubectl wait --for=condition=ready pods/recover-hermesnode -n "$NAME" --timeout=5m >/dev/null 2>&1

# note to user on resume
echo "${boldyellow}If the snapshot fails to sync resume by re-running the make target.$reset"

# unset gcloud account to access public bucket in GKE clusters with workload identity
kubectl exec -n "$NAME" -it recover-hermesnode -- /bin/sh -c 'gcloud config set account none'

# recover nine realms snapshot
echo "pulling nine realms snapshot..."
kubectl exec -n "$NAME" -it recover-hermesnode -- gsutil -m rsync -r -d \
  "gs://public-snapshots-ninerealms/hermesnode/$HEIGHT/" /root/.hermesnode/data/

echo "repeat sync pass in case of errors..."
kubectl exec -n "$NAME" -it recover-hermesnode -- gsutil rsync -r -d \
  "gs://public-snapshots-ninerealms/hermesnode/$HEIGHT/" /root/.hermesnode/data/

echo "=> ${boldgreen}Proceeding to clean up recovery pod and restart hermesnode$reset"
confirm

echo "cleaning up recover pod"
kubectl -n "$NAME" delete pod/recover-hermesnode

# start hermesnode
kubectl scale -n "$NAME" --replicas=1 deploy/hermesnode --timeout=5m
