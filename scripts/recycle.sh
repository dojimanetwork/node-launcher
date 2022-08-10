#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info

if ! node_exists; then
  die "No existing THORNode found, make sure this is the correct name"
fi

if [ "$TYPE" != "validator" ]; then
  die "Only validators should be recycled"
fi

display_status

echo -e "=> Recycling a $boldgreen$TYPE$reset THORNode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
echo
echo
warn "!!! Make sure your got your BOND back before recycling your THORNode !!!"
confirm

# delete gateway resources
echo "=> Recycling THORNode - deleting gateway resources..."
kubectl -n "$NAME" delete deployment gateway
kubectl -n "$NAME" delete service gateway
kubectl -n "$NAME" delete configmap gateway-external-ip

# delete hermesnode resources
echo "=> Recycling THORNode - deleting hermesnode resources..."
kubectl -n "$NAME" delete deployment hermesnode
kubectl -n "$NAME" delete pvc hermesnode
kubectl -n "$NAME" delete configmap hermesnode-external-ip
kubectl -n "$NAME" delete secret hermesnode-password
kubectl -n "$NAME" delete secret hermesnode-mnemonic

# delete narada resources
echo "=> Recycling THORNode - deleting narada resources..."
kubectl -n "$NAME" delete deployment narada
kubectl -n "$NAME" delete pvc narada
kubectl -n "$NAME" delete configmap narada-external-ip

# recreate resources
echo "=> Recycling THORNode - recreating deleted resources..."
NET=$NET TYPE=$TYPE NAME=$NAME ./scripts/install.sh

echo "=> Recycle complete."
