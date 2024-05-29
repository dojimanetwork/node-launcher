#!/usr/bin/env bash

set -e

source ./scripts/core.sh

: "${NAMESPACE:=snapshot-provider}"

if helm -n "${NAMESPACE}" status provider >/dev/null 2>&1; then
  helm diff -C 3 upgrade --install provider ./dependency_charts/provider -n "${NAMESPACE}" -f ./dependency_charts/provider/values.yaml
  confirm
fi

echo "=> Installing Provider"
helm upgrade --install provider ./dependency_charts/provider -n "${NAMESPACE}" --create-namespace --wait -f ./dependency_charts/provider/values.yaml
echo
