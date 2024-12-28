#!/bin/bash

# Array of namespaces
namespaces=("matrix24" "spartan-three" "spartan-four" "spartan-two" "spartan-one" "george-jye" "turtle1963" "pepperoni" "bleach1963" "validator-node-1" "validator-node-2" "devnet-priv-ssl")

# Loop through each namespace and apply Helm chart
for ns in "${namespaces[@]}"; do
  echo "Applying Helm changes to namespace: $ns"
  export NAME=$ns
  "$@" -n $ns
  "$@"
done
