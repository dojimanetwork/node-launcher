#!/usr/bin/env bash

source ./scripts/menu.sh

# reset=$(tput sgr0)              # normal text
reset=$'\e[0m'                  # (works better sometimes)
bold=$(tput bold)               # make colors bold/bright
red="$bold$(tput setaf 1)"      # bright red text
green=$(tput setaf 2)           # dim green text
boldgreen="$bold$green"         # bright green text
fawn=$(tput setaf 3)            # dark yellow text
beige="$fawn"                   # dark yellow text
yellow="$bold$fawn"             # bright yellow text
boldyellow="$bold$yellow"       # bright yellow text
darkblue=$(tput setaf 4)        # dim blue text
blue="$bold$darkblue"           # bright blue text
purple=$(tput setaf 5)          # magenta text
magenta="$purple"               # magenta text
pink="$bold$purple"             # bright magenta text
darkcyan=$(tput setaf 6)        # dim cyan text
cyan="$bold$darkcyan"           # bright cyan text
gray=$(tput setaf 7)            # dim white text
darkgray="$bold"$(tput setaf 0) # bold black = dark gray text
white="$bold$gray"              # bright white text

warn() {
  echo >&2 "$boldyellow:: $*$reset"
}

die() {
  echo >&2 "$red:: $*$reset"
  exit 1
}

confirm() {
  if [ -z "$TC_NO_CONFIRM" ]; then
    echo -n "$boldyellow:: Are you sure? Confirm [y/n]: $reset" && read -r ans && [ "${ans:-N}" != y ] && exit
  fi
  echo
}

get_node_net() {
  if [ "$NET" != "" ]; then
    if [ "$NET" != "mainnet" ] && [ "$NET" != "testnet" ] && [ "$NET" != "stagenet" ]; then
      die "Error NET variable=$NET. NET variable should be either 'mainnet', 'testnet', or 'stagenet'."
    fi
    return
  fi
  echo "=> Select net"
  menu mainnet mainnet testnet stagenet
  NET=$MENU_SELECTED
  echo
}

get_node_type() {
  [ "$TYPE" != "" ] && return
  echo "=> Select HermesNode type"
  menu validator genesis validator fullnode daemons
  TYPE=$MENU_SELECTED
  echo
}

get_node_name() {
  [ "$NAME" != "" ] && return
  case $NET in
    "mainnet")
      NAME=hermesnode
      ;;
    "stagenet")
      NAME=hermesnode-stagenet
      ;;
    "testnet")
      NAME=hermesnode-testnet
      ;;
  esac
  read -r -p "=> Enter hermesnode name [$NAME]: " name
  NAME=${name:-$NAME}
  echo
}

get_discord_channel() {
  [ "$DISCORD_CHANNEL" != "" ] && unset DISCORD_CHANNEL
  echo "=> Select hermesnode relay channel: "
  menu mainnet mainnet devops
  DISCORD_CHANNEL=$MENU_SELECTED
  echo
}

get_discord_message() {
  [ "$DISCORD_MESSAGE" != "" ] && unset DISCORD_MESSAGE
  read -r -p "=> Enter hermesnode relay messge: " discord_message
  DISCORD_MESSAGE=${discord_message:-$DISCORD_MESSAGE}
  echo
}

get_mimir_key() {
  [ "$MIMIR_KEY" != "" ] && unset MIMIR_KEY
  read -r -p "=> Enter hermesnode Mimir key: " mimir_key
  MIMIR_KEY=${mimir_key:-$MIMIR_KEY}
  echo
}

get_mimir_value() {
  [ "$MIMIR_VALUE" != "" ] && unset MIMIR_VALUE
  read -r -p "=> Enter hermesnode Mimir value: " mimir_value
  MIMIR_VALUE=${mimir_value:-$MIMIR_VALUE}
  echo
}

get_node_address() {
  [ "$NODE_ADDRESS" != "" ] && unset NODE_ADDRESS
  read -r -p "=> Enter hermesnode address to ban: " node_address
  NODE_ADDRESS=${node_address:-$NODE_ADDRESS}
  echo
}

get_node_info() {
  get_node_net
  get_node_type
  get_node_name
}

get_node_info_short() {
  [ "$NAME" = "" ] && get_node_net
  get_node_name
}

get_node_service() {
  [ "$SERVICE" != "" ] && return
  echo "=> Select hermesnode service"
  menu hermesnode hermesnode narada midgard gateway
#  binance-daemon dogecoin-daemon gaia-daemon avalanche-daemon ethereum-daemon bitcoin-daemon litecoin-daemon bitcoin-cash-daemon midgard-timescaledb
  SERVICE=$MENU_SELECTED
  echo
}

create_namespace() {
  if ! kubectl get ns "$NAME" >/dev/null 2>&1; then
    echo "=> Creating hermesnode Namespace"
    kubectl create ns "$NAME"
    echo
  fi
}

node_exists() {
  kubectl get -n "$NAME" deploy/hermesnode >/dev/null 2>&1 || kubectl get -n "$NAME" deploy/hermes-daemon >/dev/null 2>&1
}

snapshot_available() {
  kubectl get crd volumesnapshots.snapshot.storage.k8s.io >/dev/null 2>&1
}

make_snapshot() {
  local pvc
  local service
  local snapshot
  service=$1
  snapshot=$1

  if [[ -n $SNAPSHOT_SUFFIX ]]; then
    snapshot=$snapshot-$SNAPSHOT_SUFFIX
  fi

  if [ "$service" == "midgard" ]; then
    pvc="data-midgard-timescaledb-0"
  else
    pvc=$service
  fi
  if ! kubectl -n "$NAME" get pvc "$pvc" >/dev/null 2>&1; then
    warn "Volume $pvc not found"
    echo
    exit 0
  fi

  echo
  echo "=> Snapshotting service $boldgreen$service$reset of a HermesNode named $boldgreen$NAME$reset"
  if [ -z "$TC_NO_CONFIRM" ]; then
    echo -n "$boldyellow:: Are you sure? Confirm [y/n]: $reset" && read -r ans && [ "${ans:-N}" != y ] && return
  fi
  echo

  if kubectl -n "$NAME" get volumesnapshot "$snapshot" >/dev/null 2>&1; then
    echo "Existing snapshot $boldgreen$snapshot$reset exists, ${boldyellow}continuing will overwrite${reset}"
    confirm
    kubectl -n "$NAME" delete volumesnapshot "$snapshot" >/dev/null 2>&1 || true
  fi

  cat <<EOF | kubectl -n "$NAME" apply -f -
    apiVersion: snapshot.storage.k8s.io/v1beta1
    kind: VolumeSnapshot
    metadata:
      name: $snapshot
    spec:
      source:
        persistentVolumeClaimName: $pvc
EOF
  echo
  echo "=> Waiting for $boldgreen$service$reset snapshot $boldyellow$snapshot$reset to be ready to use (can take up to an hour depending on service and provider)"
  until kubectl -n "$NAME" get volumesnapshot "$snapshot" -o yaml | grep "readyToUse: true" >/dev/null 2>&1; do sleep 10; done
  echo "Snapshot $boldyellow$snapshot$reset for $boldgreen$service$reset created"
  echo
}

make_backup() {
  local service
  local spec
  service=$1

  if [ "$service" = "narada" ]; then
    spec="
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
            \"name\": \"$service\",
            \"image\": \"busybox:1.33\",
            \"volumeMounts\": [
              {\"mountPath\": \"/root/.hermesnode\", \"name\": \"data\", \"subPath\": \"hermesnode\"},
              {\"mountPath\": \"/var/data/narada\", \"name\": \"data\", \"subPath\": \"data\"}
            ]
          }
        ],
        \"volumes\": [{\"name\": \"data\", \"persistentVolumeClaim\": {\"claimName\": \"$service\"}}]
      }
    }"
  else
    spec="
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
            \"name\": \"$service\",
            \"image\": \"busybox:1.33\",
            \"volumeMounts\": [{\"mountPath\": \"/root\", \"name\":\"data\"}]
          }
        ],
        \"volumes\": [{\"name\": \"data\", \"persistentVolumeClaim\": {\"claimName\": \"$service\"}}]
      }
    }"

  fi

  echo
  echo "=> Backing up service $boldgreen$service$reset from hermesnode in $boldgreen$NAME$reset"
  confirm

  local pod
  pod="deploy/$service"
  if (kubectl get pod -n "$NAME" -l "app.kubernetes.io/name=$service" 2>&1 | grep "No resources found") >/dev/null 2>&1; then
    kubectl run -n "$NAME" "backup-$service" --restart=Never --image="busybox:1.33" --overrides="$spec"
    kubectl wait --for=condition=ready pods "backup-$service" -n "$NAME" --timeout=5m >/dev/null 2>&1
    pod="pod/backup-$service"
  fi

  local seconds
  local day
  seconds=$(date +%s)
  day=$(date +%Y-%m-%d)
  mkdir -p "backups/$NAME/$service/$day"
  if [ "$service" = "narada" ]; then
    kubectl exec -it -n "$NAME" "$pod" -c "$service" -- sh -c "cd /root/.hermesnode && tar cfz \"$service-$seconds.tar.gz\" localstate-*.json"
  else
    kubectl exec -it -n "$NAME" "$pod" -c "$service" -- sh -c "cd /root/.hermesnode && tar cfz \"$service-$seconds.tar.gz\" config/"
  fi
  kubectl exec -n "$NAME" "$pod" -c "$service" -- sh -c "cd /root/.hermesnode && tar cfz - \"$service-$seconds.tar.gz\"" | tar xfz - -C "$PWD/backups/$NAME/$service/$day"

  if (kubectl get pod -n "$NAME" -l "app.kubernetes.io/name=$service" 2>&1 | grep "No resources found") >/dev/null 2>&1; then
    kubectl delete pod --now=true -n "$NAME" "backup-$service"
  fi

  echo "Backup available in path ./backups/$NAME/$service/$day"
}

create_mnemonic() {
  local mnemonic
  if ! kubectl get -n "$NAME" secrets/hermesnode-mnemonic >/dev/null 2>&1; then
    echo "=> Generating hermesnode Mnemonic phrase"
    mnemonic=$(kubectl run -n "$NAME" -it --rm mnemonic --image=576263512135.dkr.ecr.ap-south-1.amazonaws.com/hermes/hermes-node:testnet-1.89.0_12 --restart=Never --command -- generate | grep MASTER_MNEMONIC | cut -d '=' -f 2 | tr -d '\r')
#     mnemonic="wink umbrella toss bleak patient extend palm asthma divorce quit track planet depend tenant mimic shiver girl segment lend unit body account monster lizard"
    [ "$mnemonic" = "" ] && die "Mnemonic generation failed. Please try again."
    kubectl -n "$NAME" create secret generic hermesnode-mnemonic --from-literal=mnemonic="$mnemonic"
    echo
  fi
}

create_password() {
  [ "$NET" = "testnet" ] && return
  local pwd
  local pwdconf
  if ! kubectl get -n "$NAME" secrets/hermesnode-password >/dev/null 2>&1; then
    echo "=> Creating hermesnode Password"
    read -r -s -p "Enter password: " pwd
    echo
    read -r -s -p "Confirm password: " pwdconf
    echo
    [ "$pwd" != "$pwdconf" ] && die "Passwords mismatch"
    kubectl -n "$NAME" create secret generic hermesnode-password --from-literal=password="$pwd"
    echo
  fi
}

display_mnemonic() {
  kubectl get -n "$NAME" secrets/hermesnode-mnemonic --template="{{.data.mnemonic}}" | base64 --decode
  echo
}

display_pods() {
  kubectl get -n "$NAME" pods
}

display_password() {
  kubectl get -n "$NAME" secrets/hermesnode-password --template="{{.data.password}}" | base64 --decode
}

display_status() {
  local ready
  ready=$(kubectl get pod -n "$NAME" -l app.kubernetes.io/name=hermesnode -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}')
  if [ "$ready" = "True" ]; then
    if kubectl exec -it -n "$NAME" deploy/hermesnode -c hermesnode -- /scripts/node-status.sh | tee /dev/tty | grep -E "^STATUS\s+Active" >/dev/null; then
      if [ -z "$TC_NO_BACKUP" ]; then
        echo -e "\n=> Detected ${red}active$reset validator hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
        make_backup narada
      fi
    fi
  else
    echo "hermesnode pod is not currently running, status is unavailable"
  fi
  return
}

deploy_genesis() {
  local args
  [ "$NET" = "mainnet" ] && args="--set global.passwordSecret=hermesnode-password"
  [ "$NET" = "stagenet" ] && args="--set global.passwordSecret=hermesnode-password"
  # shellcheck disable=SC2086
  helm diff upgrade -C 3 --install "$NAME" ./hermes-stack -n "$NAME" \
    $args $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.type="genesis"
  echo "args --- ${args}"
  echo "extra args ${EXTRA_ARGS}"
  echo -e "=> Changes for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
#  confirm
  # shellcheck disable=SC2086
  helm upgrade --install "$NAME" ./hermes-stack -n "$NAME" \
    --create-namespace $args $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.type="genesis"

  echo -e "=> Restarting gateway for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
#  confirm
  kubectl -n "$NAME" rollout restart fhermesnode-gateway
}

deploy_validator() {
  local args
  [ "$NET" = "mainnet" ] && args="--set global.passwordSecret=hermesnode-password"
  [ "$NET" = "stagenet" ] && args="--set global.passwordSecret=hermesnode-password"
  # shellcheck disable=SC2086
  helm diff upgrade -C 3 --install "$NAME" ./hermes-stack -n "$NAME" \
    $args $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.type="validator" \
    --set narada.peer="$SEED",hermesnode.seeds="$SEED"
  echo -e "=> Changes for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
  confirm
  # shellcheck disable=SC2086
  helm upgrade --install "$NAME" ./hermes-stack -n "$NAME" \
    --create-namespace $args $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.type="validator" \
    --set narada.peer="$SEED",hermesnode.seeds="$SEED"

  [ "$TYPE" = "daemons" ] && return

  echo -e "=> Restarting gateway for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
  confirm
  kubectl -n "$NAME" rollout restart deploy hermes-gateway
}

deploy_fullnode() {
  # shellcheck disable=SC2086
  helm diff upgrade -C 3 --install "$NAME" ./hermes-stack -n "$NAME" \
    $args $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.seeds="$SEED" \
    --set midgard.enabled=true,narada.enabled=false,binance-daemon.enabled=false \
    --set bitcoin-daemon.enabled=false,bitcoin-cash-daemon.enabled=false \
    --set litecoin-daemon.enabled=false,ethereum-daemon.enabled=false \
    --set dogecoin-daemon.enabled=false,gaia-daemon.enabled=false \
    --set avalanche-daemon.enabled=false \
    --set hermesnode.type="fullnode",gateway.validator=false,gateway.midgard=true,gateway.rpc.limited=false,gateway.api=true
  echo -e "=> Changes for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
  confirm
  # shellcheck disable=SC2086
  helm upgrade --install "$NAME" ./hermes-stack -n "$NAME" \
    --create-namespace $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.seeds="$SEED" \
    --set midgard.enabled=true,narada.enabled=false,binance-daemon.enabled=false \
    --set bitcoin-daemon.enabled=false,bitcoin-cash-daemon.enabled=false \
    --set litecoin-daemon.enabled=false,ethereum-daemon.enabled=false \
    --set dogecoin-daemon.enabled=false,gaia-daemon.enabled=false \
    --set avalanche-daemon.enabled=false \
    --set hermesnode.type="fullnode",gateway.validator=false,gateway.midgard=true,gateway.rpc.limited=false,gateway.api=true

  echo -e "=> Restarting gateway for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
  confirm
  kubectl -n "$NAME" rollout restart deploy hermes-gateway
}
