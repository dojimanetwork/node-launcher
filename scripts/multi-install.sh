#!/bin/bash

# Array of namespaces
namespaces=("matrix24" "spartan-three" "spartan-four" "george-jye" "turtle24" "pepperonipizza90")

# Loop through each namespace and apply Helm chart
for ns in "${namespaces[@]}"; do
  echo "Applying Helm changes to namespace: $ns"
  export NAME=$ns
#  "$@" -n $ns
  "$@"
done
