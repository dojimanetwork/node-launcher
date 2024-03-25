#!/usr/bin/env bash
set -euo pipefail

# Thin wrapper around the upstream helm installer script:
#   https://github.com/helm/helm/blob/main/scripts/get-helm-3

INSTALLER="/tmp/get-helm-3"

curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 >$INSTALLER
SHA256=$(sha256sum $INSTALLER | awk '{print $1}')
echo $SHA256
if [ "$SHA256" != "f29d8f3cc0f26dcbaf9dc67f815224d2a1a074e0cb1c6e79d9eb8600c98ab682" ]; then
  cat <<EOF
Upstream contents of Helm installer script have changed.
Please verify the new script is safe, then update the hash here.
EOF
  exit 1
fi

# Explicitly enable checksum verification.
export VERIFY_CHECKSUM="true"

# Explicitly enable signature verification if on Linux (other platforms not supported).
if [ "$(uname)" == "Linux" ]; then
  export VERIFY_SIGNATURE="true"
fi

chmod +x $INSTALLER

$INSTALLER

rm -f $INSTALLER
