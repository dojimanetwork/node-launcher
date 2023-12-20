#!/bin/bash

set -ex

BNET=${BNET:-testnet}
EXE="ulimit -n 65535 && /release/linux/bnbchaind start --home ${BNCHOME}"

# initialize config
if [ ! -d "${BNCHOME}/config/" ]; then
  cp -r "/release/${BNET}" "${BNCHOME}/config/"
fi
chown -R bnbchaind:bnbchaind "${BNCHOME}/config/"

# turn on console logging
sed -i 's/logToConsole = false/logToConsole = true/g' "${BNCHOME}/config/app.toml"

# enable telemetry
sed -i "s/prometheus = false/prometheus = true/g" "${BNCHOME}/config/config.toml"
sed -i -e "s/prometheus_listen_addr = \":26660\"/prometheus_listen_addr = \":28660\"/g" "${BNCHOME}/config/config.toml"

# reduce log noise
sed -i "s/consensus:info/consensus:error/g" "${BNCHOME}/config/config.toml"
sed -i "s/dexkeeper:info/dexkeeper:error/g" "${BNCHOME}/config/config.toml"
sed -i "s/dex:info/dex:error/g" "${BNCHOME}/config/config.toml"
sed -i "s/state:info/state:error/g" "${BNCHOME}/config/config.toml"

# fix testnet seed
if [ "${BNET}" == "testnet" ]; then
  sed -i -e "s/seeds =.*/seeds = \"3a18f4189fe54af14e9c2da1d6edeb9a23eca445@184.72.122.37;52157533d7ae8089517f4f7e1de9282276e8047c@3.114.127.147:27146\"/g" "${BNCHOME}/config/config.toml"
fi

echo "Running $0 in $PWD"
su bnbchaind -c "$EXE"
