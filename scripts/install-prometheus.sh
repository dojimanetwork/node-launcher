#!/usr/bin/env bash

set -e

source ./scripts/core.sh

if helm status prometheus >/dev/null 2>&1; then
  helm diff -C 3 upgrade --install prometheus prometheus-community/kube-prometheus-stack -n prometheus -f ./prometheus/values.yaml
  confirm
fi

echo "=> Installing Prometheus/Grafana Stack"
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -n prometheus --create-namespace --wait -f ./prometheus/values.yaml
echo
