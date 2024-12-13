#!/usr/bin/env bash

set -e

# create recover pod
echo "creating arbitrum token bridge contracts pod"
cat <<EOF | kubectl apply -f -
  # ConfigMap to store shell scripts
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: token-bridge-scripts
    namespace: ${NAME}
  data:
    deploy.sh: |
      #!/bin/sh
      echo "Deploying contracts..."
      # Add your contract deployment logic here
      echo "Deployment complete!"

___


apiVersion: v1
kind: Pod
metadata:
  name: token-bride-contracts-arbitrum
  namespace: ${NAME}
spec:
  initContainers:
  - name: init-deploy-contracts
    image: alpine:latest@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454
    command:
      - sh
      - -c
      - |
        chmod +x /scripts/deploy.sh
        /scripts/deploy.sh
    volumeMounts:
    - mountPath: /scripts
      name: script-config
    - mountPath: /root
      name: data
  containers:
  - name: placeholder
    image: alpine:latest
    command:
      - sh
      - -c
      - |
        echo "InitContainer complete. This container is here to satisfy Kubernetes requirements."
    resources:
      requests:
        cpu: "10m"
        memory: "16Mi"
  restartPolicy: Never
  volumes:
    - name: script-config
      configMap:
        name: token-bridge-scripts
EOF

# reset node state
echo "waiting for recover pod to be ready..."
kubectl wait --for=condition=ready pods/token-bride-contracts-arbitrum -n "${NAME}" --timeout=5m >/dev/null 2>&1

echo "=> ${boldgreen}Proceeding to clean up recovery pod and restart hermesnode${reset}"
confirm

echo "cleaning up recover pod"
kubectl -n "${NAME}" delete pod/restore-external-hermesnode
