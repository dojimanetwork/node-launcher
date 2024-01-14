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
    if [ "$NET" != "mainnet" ] && [ "$NET" != "testnet" ] && [ "$NET" != "stagenet" ] && [ "$NET" != "devnet" ]; then
      die "Error NET variable=$NET. NET variable should be either 'mainnet', 'testnet', or 'stagenet' or 'devnet'."
    fi
    return
  fi
  echo "=> Select net"
  menu mainnet mainnet testnet stagenet devnet
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
    "devnet")
      NAME=hermesnode-devnet
      ;;
  esac
  read -r -p "=> Enter hermesnode name [$NAME]: " name
  NAME=${name:-$NAME}
  echo
}

get_hermes_gateway() {
  if [ "$HERMES_GATEWAY" != "" ]; then
      return
    fi
    read -r -p "=> Enter frontend gateway name [$HERMES_GATEWAY]: " name
    HERMES_GATEWAY=${name:-$HERMES_GATEWAY}
}

get_frontend_gateway() {
  if [ "$FRONTEND_GATEWAY" != "" ]; then
    return
  fi
  read -r -p "=> Enter frontend gateway name [$FRONTEND_GATEWAY]: " name
  FRONTEND_GATEWAY=${name:-$FRONTEND_GATEWAY}
}

get_frontend_net() {
    if [ "$FRONTEND_NET" != "" ]; then
      if [ "$FRONTEND_NET" != "mainnet" ] && [ "$FRONTEND_NET" != "testnet" ] && [ "$FRONTEND_NET" != "stagenet" ]; then
        die "Error NET variable=$FRONTEND_NET. FRONTEND_NET variable should be either 'mainnet', 'testnet', or 'stagenet'."
      fi
      return
    fi
    echo "=> Select net"
    menu mainnet mainnet testnet stagenet
    NET=$MENU_SELECTED
    echo
}

get_frontend_namespace_name() {
  [ "$FRONTEND_NAME" != "" ] && return
  case $NET in
    "mainnet")
      FRONTEND_NAME=frontend-apps
      ;;
    "stagenet")
      FRONTEND_NAME=frontend-apps-stagenet
      ;;
    "testnet")
      FRONTEND_NAME=frontend-apps-testnet
      ;;
  esac
  read -r -p "=> Enter frontend-apps name [$FRONTEND_NAME]: " name
  FRONTEND_NAME=${name:-$FRONTEND_NAME}
  echo
}



get_backend_gateway() {
  if [ "$BACKEND_GATEWAY" != "" ]; then
    return
  fi
  read -r -p "=> Enter backend gateway name [$BACKEND_GATEWAY]: " name
  BACKEND_GATEWAY=${name:-$BACKEND_GATEWAY}
}

get_backend_net() {
    if [ "$BACKEND_NET" != "" ]; then
      if [ "$BACKEND_NET" != "mainnet" ] && [ "$BACKEND_NET" != "testnet" ] && [ "$BACKEND_NET" != "stagenet" ]; then
        die "Error NET variable=$BACKEND_NET. $BACKEND_NET variable should be either 'mainnet', 'testnet', or 'stagenet'."
      fi
      return
    fi
    echo "=> Select net"
    menu mainnet mainnet testnet stagenet
    NET=$MENU_SELECTED
    echo
}

get_backend_namespace_name() {
  [ "$BACKEND_NAME" != "" ] && return
  case $NET in
    "mainnet")
      BACKEND_NAME=backend-apps
      ;;
    "stagenet")
      BACKEND_NAME=backend-apps-stagenet
      ;;
    "testnet")
      BACKEND_NAME=backend-apps-testnet
      ;;
  esac
  read -r -p "=> Enter frontend-apps name [$BACKEND_NAME]: " name
  BACKEND_NAME=${name:-$BACKEND_NAME}
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

get_frontend_info() {
  get_frontend_namespace_name
  get_frontend_net
  get_frontend_gateway
}

get_backend_info() {
  get_backend_namespace_name
  get_backend_net
  get_backend_gateway
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
    echo "=> Creating hermesnode namespace"
    kubectl create ns "$NAME"
    echo
  fi
}

create_frontend_namespace(){
    if ! kubectl get ns "$FRONTEND_NAME" >/dev/null 2>&1; then
      echo "=> Creating frontend-apps namespace"
      kubectl create ns "$FRONTEND_NAME"
      echo
    fi
}

create_backend_namespace(){
    if ! kubectl get ns "$BACKEND_NAME" >/dev/null 2>&1; then
      echo "=> Creating backend-apps namespace"
      kubectl create ns "$BACKEND_NAME"
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

get_hermesnode_image() {
  [ -z "$EXTRA_ARGS" ] && die "Cannot determine hermesnode image"
  # shellcheck disable=SC2086
  (
    set -eo pipefail
    net=$(get_node_net)
    helm template ./hermes-stack $EXTRA_ARGS | grep "image:.*/${NET}/hermes" | head -n1 | awk '{print $2}'
  )
}

create_mnemonic() {
  local mnemonic
  local prompt_mnemonic
  # Do nothing if mnemonic already exists.
  if ! kubectl get -n "$NAME" secrets/hermesnode-mnemonic >/dev/null 2>&1; then
    read -r -s -p "Enter mnemonic seed phrase: " prompt_mnemonic
    if [ prompt_mnemonic == "" ]; then
      echo "=> Generating hermesnode Mnemonic phrase"
      image=$(get_hermes_image)
      echo $image
      mnemonic=$(kubectl run -n "$NAME" -it --rm mnemonic --image="$image" --restart=Never --command -- generate | grep MASTER_MNEMONIC | cut -d '=' -f 2 | tr -d '\r')
      kubectl wait --for=condition=ready pods mnemonic -n "$NAME" --timeout=5m >/dev/null 2>&1
      [ "$mnemonic" = "" ] && die "Mnemonic generation failed. Please try again."
      kubectl -n "$NAME" create secret generic hermesnode-mnemonic --from-literal=mnemonic="$mnemonic"
      kubectl -n "$NAME" delete pod --now=true mnemonic
      return
    else
      mnemonic=$prompt_mnemonic
    fi
    [ "$mnemonic" = "" ] && die "Mnemonic generation failed. Please try again."
    kubectl -n "$NAME" create secret generic hermesnode-mnemonic --from-literal=mnemonic="$mnemonic"
  fi
}

create_password() {
#  [ "$NET" = "testnet" ] && return
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
  APP=hermesnode
  if [ "$TYPE" = "validator" ]; then
    APP=bifrost
  fi

  local initialized
  initialized=$(kubectl get pod -n "$NAME" -l app.kubernetes.io/name=$APP -o 'jsonpath={..status.conditions[?(@.type=="Initialized")].status}')
  if [ "$initialized" = "True" ]; then
    local output
    output=$(kubectl exec -it -n "$NAME" deploy/$APP -c $APP -- /scripts/node-status.sh | tee /dev/tty)
    NODE_ADDRESS=$(awk '$1 ~ /ADDRESS/ {match($2, /[a-z0-9]+/); print substr($2, RSTART, RLENGTH)}' <<<"$output")

    if grep -E "^STATUS\s+Active" <<<"$output" >/dev/null; then
      echo -e "\n=> Detected ${red}active$reset validator Hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"

      # prompt for missing mimir votes if mainnet
      if [ "$NET" = "mainnet" ]; then
        echo "=> Checking for missing mimir votes..."

        # all reminder votes the node is missing
        local missing_votes
        missing_votes=$(kubectl exec -it -n "$NAME" deploy/thornode -c thornode -- curl -s http://localhost:1317/hermeschain/hermset/nodes_all |
          jq -r "$(curl -s https://api.ninerealms.com/thorchain/votes | jq -c) - [.mimirs[] | select(.signer==\"$NODE_ADDRESS\") | .key] | .[]")

        if [ -n "$missing_votes" ]; then
          echo
          echo "$red=> Please vote for the following unvoted mimir values:$reset"
          echo "$missing_votes"
        fi
      fi
    fi

  else
    echo "HERMESNode pod is not currently running, status is unavailable"
  fi
  return
}

deploy_genesis() {
  local args
  [ "$NET" = "mainnet" ] && args="--set global.passwordSecret=hermesnode-password"
  [ "$NET" = "stagenet" ] && args="--set global.passwordSecret=hermesnode-password"
  [ "$NET" = "testnet" ] && args="--set global.passwordSecret=hermesnode-password"
  # shellcheck disable=SC2086
  helm diff upgrade -C 3 --install "$NAME" ./hermes-stack -n "$NAME" \
    $args $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.type="genesis" \
    --set global.namespace="$NAME"

  echo "args --- ${args}"
  echo "extra args ${EXTRA_ARGS}"
  echo -e "=> Changes for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
  confirm
  # shellcheck disable=SC2086
  helm upgrade --install "$NAME" ./hermes-stack -n "$NAME" \
    --create-namespace $args $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.type="genesis" \
    --set global.namespace="$NAME"

  echo -e "=> Restarting gateway for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
  confirm
  kubectl rollout restart -n "${NAME}" deployment "${HERMES_GATEWAY}"
}

deploy_frontend() {
  local args
  # shellcheck disable=SC2086
  helm diff upgrade -C 3 --install "$FRONTEND_NAME" ./frontend-apps -n "$FRONTEND_NAME" \
    $args $EXTRA_ARGS \
    --set global.net="$FRONTEND_NET"
  echo "extra args ${EXTRA_ARGS}"
    echo -e "=> Changes for a  frontend-apps on $boldgreen$FRONTEND_NET$reset named $boldgreen$FRONTEND_NAME$reset"

    confirm
  # shellcheck disable=SC2086
  helm upgrade --install "$FRONTEND_NAME" ./frontend-apps -n "$FRONTEND_NAME" \
    --create-namespace $args $EXTRA_ARGS \
    --set global.net="$FRONTEND_NET" \

  confirm

  kubectl rollout restart -n "${FRONTEND_NAME}" deployment "${FRONTEND_GATEWAY}"
}

deploy_backend() {
  local args
  # shellcheck disable=SC2086
  helm diff upgrade -C 3 --install "$BACKEND_NAME" ./backend-apps -n "$BACKEND_NAME" \
    $args $EXTRA_ARGS \
    --set global.net="$BACKEND_NET"
  echo "extra args ${EXTRA_ARGS}"
    echo -e "=> Changes for a  frontend-apps on $boldgreen$BACKEND_NET$reset named $boldgreen$BACKEND_NAME$reset"

  #  confirm
  # shellcheck disable=SC2086
  helm upgrade --install "$BACKEND_NAME" ./backend-apps -n "$BACKEND_NAME" \
    --create-namespace $args $EXTRA_ARGS \
    --set global.net="$BACKEND_NET" \
    --skip-crds \
#  confirm
  kubectl rollout restart -n "${BACKEND_NAME}" deployment "${BACKEND_GATEWAY}"
}

deploy_validator() {
  local args
  [ "$NET" = "mainnet" ] && args="--set global.passwordSecret=hermesnode-password"
  [ "$NET" = "stagenet" ] && args="--set global.passwordSecret=hermesnode-password"
  [ "$NET" = "testnet" ] && args="--set global.passwordSecret=hermesnode-password"
  # shellcheck disable=SC2086
  helm diff upgrade -C 3 --install "$NAME" ./hermes-stack -n "$NAME" \
    $args $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.type="validator" \
    --set narada.peer="$SEED",hermesnode.seeds="$SEED" \
    --set global.namespace="$NAME"
  echo -e "=> Changes for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
#  confirm
  # shellcheck disable=SC2086
  helm upgrade --install "$NAME" ./hermes-stack -n "$NAME" \
    --create-namespace $args $EXTRA_ARGS \
    --set global.mnemonicSecret=hermesnode-mnemonic \
    --set global.net="$NET" \
    --set hermesnode.type="validator" \
    --set narada.peer="$SEED",hermesnode.seeds="$SEED" \
    --set global.namespace="$NAME"

  [ "$TYPE" = "daemons" ] && return

  echo -e "=> Restarting gateway for a $boldgreen$TYPE$reset hermesnode on $boldgreen$NET$reset named $boldgreen$NAME$reset"
#  confirm
  kubectl -n "$NAME" rollout restart deployment "${HERMES_GATEWAY}"
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
  kubectl -n "$NAME" rollout restart deploy "${HERMES_GATEWAY}"
}
