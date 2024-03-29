#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info

if ! node_exists; then
  die "No existing Hermesnode found, make sure this is the correct name"
fi

if [ "$TYPE" != "validator" ]; then
  die "Only validators should be recycled"
fi

display_status

echo -e "=> Recycling a $boldgreen$TYPE$reset Hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
echo
echo
warn "!!! Make sure your got your BOND back before recycling your Hermesnode !!!"
confirm

# delete gateway resources
echo "=> Recycling Hermesnode - deleting gateway resources..."
kubectl -n "$NAME" delete deployment gateway
kubectl -n "$NAME" delete service gateway
kubectl -n "$NAME" delete configmap gateway-external-ip

# delete hermesnode resources
echo "=> Recycling Hermesnode - deleting hermesnode resources..."
kubectl -n "$NAME" delete deployment hermesnode
kubectl -n "$NAME" delete pvc hermesnode
kubectl -n "$NAME" delete configmap hermesnode-external-ip
kubectl -n "$NAME" delete secret hermesnode-password
kubectl -n "$NAME" delete secret hermesnode-mnemonic

# delete narada resources
echo "=> Recycling Hermesnode - deleting narada resources..."
kubectl -n "$NAME" delete deployment narada
kubectl -n "$NAME" delete pvc narada
kubectl -n "$NAME" delete configmap narada-external-ip

# recreate resources
echo "=> Recycling Hermesnode - recreating deleted resources..."
NET=$NET TYPE=$TYPE NAME=$NAME ./scripts/install.sh

echo "=> Recycle complete."
