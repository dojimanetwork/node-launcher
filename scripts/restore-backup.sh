#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

if ! node_exists; then
  die "No existing Hermesnode found, make sure this is the correct name"
fi

echo "=> Select a HermesNode service to restore a backup from"
menu hermesnode hermesnode narada
SERVICE=$MENU_SELECTED

if ! kubectl -n "$NAME" get pvc "$SERVICE" >/dev/null 2>&1; then
  warn "Volume $SERVICE not found"
  echo
  exit 0
fi

FILE=$(find "$PWD/backups/$SERVICE" -maxdepth 1 -type f -exec basename {} \; | sort -r | head -1)
if [ "$FILE" == "" ]; then
  warn "No backup file found for service $SERVICE"
  echo
  exit 0
fi

if [ "$SERVICE" = "narada" ]; then
  SPEC="
  {
    \"apiVersion\": \"v1\",
    \"spec\": {
      \"containers\": [
        {
          \"command\": [
            \"sh\",
            \"-c\",
            \"sleep 300\"
          ],
          \"name\": \"$SERVICE\",
          \"image\": \"busybox:1.33\",
          \"volumeMounts\": [
            {\"mountPath\": \"/root/.hermesnode\", \"name\": \"data\", \"subPath\": \"hermesnode\"},
            {\"mountPath\": \"/var/data/narada\", \"name\": \"data\", \"subPath\": \"data\"}
          ]
        }
      ],
      \"volumes\": [{\"name\": \"data\", \"persistentVolumeClaim\": {\"claimName\": \"$SERVICE\"}}]
    }
  }"
else
  SPEC="
  {
    \"apiVersion\": \"v1\",
    \"spec\": {
      \"containers\": [
        {
          \"command\": [
            \"sh\",
            \"-c\",
            \"sleep 300\"
          ],
          \"name\": \"$SERVICE\",
          \"image\": \"busybox:1.33\",
          \"volumeMounts\": [{\"mountPath\": \"/root\", \"name\":\"data\"}]
        }
      ],
      \"volumes\": [{\"name\": \"data\", \"persistentVolumeClaim\": {\"claimName\": \"$SERVICE\"}}]
    }
  }"

fi

echo
echo "=> Restoring backup service $boldgreen$SERVICE$reset from Hermesnode in $boldgreen$NAME$reset using backup $boldgreen$FILE$reset"
confirm

POD="deploy/$SERVICE"
if (kubectl get pod -n "$NAME" -l "app.kubernetes.io/name=$SERVICE" 2>&1 | grep "No resources found") >/dev/null 2>&1; then
  kubectl run -n "$NAME" "backup-$SERVICE" --restart=Never --image="busybox:1.33" --overrides="$SPEC"
  kubectl wait --for=condition=ready pods "backup-$SERVICE" -n "$NAME" --timeout=5m >/dev/null 2>&1
  POD="pod/backup-$SERVICE"
fi

tar -C "$PWD/backups/$SERVICE" -cf - "$FILE" | kubectl exec -i -n "$NAME" "$POD" -c "$SERVICE" -- tar xf - -C /root/.hermesnode

kubectl exec -it -n "$NAME" "$POD" -c "$SERVICE" -- sh -c "cd /root/.hermesnode && tar xf \"$FILE\""

if (kubectl get pod -n "$NAME" -l "app.kubernetes.io/name=$SERVICE" 2>&1 | grep "No resources found") >/dev/null 2>&1; then
  kubectl delete pod --now=true -n "$NAME" "backup-$SERVICE"
fi

echo "Restore backup successful for $SERVICE"
