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
  die "No existing HERMESNode found, make sure this is the correct name"
fi

# stop hermesnode
echo "stopping hermesnode..."
kubectl scale -n "${NAME}" --replicas=0 deploy/hermesnode --timeout=5m
kubectl wait --for=delete pods -l app.kubernetes.io/name=hermesnode -n "${NAME}" --timeout=5m >/dev/null 2>&1 || true
seconds=$(date +%s)
day=$(date +%Y-%m-%d)
backup_pod="backup-hermesnode"
service="hermesnode"
path="/root/.hermesnode/"
# create recover pod
echo "creating recover pod"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ${backup_pod}
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
      claimName: hermesnode
EOF

# reset node state
echo "waiting for recover pod to be ready..."
kubectl wait --for=condition=ready pods/"${backup_pod}" -n "${NAME}" --timeout=5m >/dev/null 2>&1

echo "installing dependencies..."
kubectl exec -n "${NAME}" -it "${backup_pod}" -- sh -c 'apk update && apk add aria2 pv'

echo "creating tar file..."
kubectl exec  -n "$NAME" -it "${backup_pod}" -- sh -c "cd $path && tar cfz \"$service-$seconds.tar.gz\" data/ -v"

echo "=> ${boldgreen}Proceeding to clean up recovery pod and restart hermesnode${reset}"
confirm

echo "cleaning up recover pod"
kubectl -n "${NAME}" delete pod/"${backup_pod}"

# start hermesnode
kubectl scale -n "${NAME}" --replicas=1 deploy/hermesnode --timeout=5m
