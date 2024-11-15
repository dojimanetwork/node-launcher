#!/usr/bin/env bash

set -e

# check the xmllint command is available
if ! command -v xmllint >/dev/null 2>&1; then
  echo "=> xmllint command not found, please install libxml2 and/or libxml2-utils"
  exit 1
fi

NET=stagenet

source ./scripts/core.sh

get_node_info_short

# trunk-ignore(shellcheck/SC2310)
if ! node_exists; then
  die "No existing Dojima Chain found, make sure this is the correct name"
fi

# select snapshot provider
PROVIDER="https://dojimachain1401.blob.core.windows.net/2024-08-08/dojima-chain-1723121837.tar.gz"
#read -r -p "=> Enter provider [${PROVIDER}]: " provider
#PROVIDER=${provider:-${PROVIDER}}
#echo
#
## get all available snapshot heights
#HEIGHTS=$(
#  set -o pipefail
#  curl -s "${PROVIDER}/snapshots?prefix=thornode" |
#    xmllint --xpath '//*[local-name()="Contents"]/*[local-name()="Key"]/text()' - |
#    grep -oE '[0-9]+' |
#    sort -nr |
#    head -n 10
#)
#readarray -t HEIGHTS <<<"${HEIGHTS}"

#echo "=> Select block height to recover"
## shellcheck disable=SC2068
#menu "${HEIGHTS[0]}" ${HEIGHTS[@]}
#HEIGHT=${MENU_SELECTED}

#echo "=> Recovering snapshot at height ${HEIGHT} on THORNode in ${boldgreen}${NAME}${reset}"
#confirm

# stop hermesnode
echo "stopping Dojima chain node..."
kubectl scale -n "${NAME}" --replicas=0 deploy/dojima-chain --timeout=5m
kubectl wait --for=delete pods -l app.kubernetes.io/name=dojima-chain -n "${NAME}" --timeout=5m >/dev/null 2>&1 || true

# create recover pod
echo "creating recover pod"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: restore-external-dojima-chain
  namespace: ${NAME}
spec:
  containers:
  - name: recover
    image: alpine:latest@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454
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
      claimName: dojima-chain
EOF

# reset node state
echo "waiting for recover pod to be ready..."
kubectl wait --for=condition=ready pods/restore-external-dojima-chain -n "${NAME}" --timeout=5m >/dev/null 2>&1

echo "clearing existing data directory..."
kubectl exec -n "${NAME}" -it restore-external-dojima-chain -- rm -rf /root/.dojimachain/dojimachain/

echo "installing dependencies..."
kubectl exec -n "${NAME}" -it restore-external-dojima-chain -- sh -c 'apk update && apk add aria2 pv'

echo "pulling snapshot..."
kubectl exec -n "${NAME}" -it restore-external-dojima-chain -- aria2c \
  --split=16 --max-concurrent-downloads=16 --max-connection-per-server=16 \
  --continue --min-split-size=100M --out="/root/dojima-chain.tar.gz" \
  "${PROVIDER}"

echo "extracting snapshot..."
kubectl exec -n "${NAME}" -it restore-external-dojima-chain -- sh -c "mkdir -p /root/.dojimachain/"
kubectl exec -n "${NAME}" -it restore-external-dojima-chain -- sh -c "pv \"/root/dojima-chain.tar.gz\" | tar xzf - -C /root/.dojimachain/"
kubectl exec -n "${NAME}" -it restore-external-dojima-chain -- sh -c "ls -lsart /root/.dojimachain && ls -lsart /root/.dojimachain/dojimachain/"

echo "removing snapshot..."
kubectl exec -n "${NAME}" -it restore-external-dojima-chain -- rm -rf "/root/dojima-chain.tar.gz"

echo "=> ${boldgreen}Proceeding to clean up recovery pod and restart dojima-chain${reset}"
confirm

echo "cleaning up recover pod"
kubectl -n "${NAME}" delete pod/restore-external-dojima-chain

# start thornode
kubectl scale -n "${NAME}" --replicas=1 deploy/dojima-chain --timeout=5m
