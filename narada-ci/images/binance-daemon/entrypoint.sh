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
  sed -i -e "s/seeds =.*/seeds = \"2726550182cbc5f4618c27e49c730752a96901e8@184.72.122.37:27146,9612b570bffebecca4776cb4512d08e252119005@3.114.127.147:27146\"/g" "${BNCHOME}/config/config.toml"
fi

echo "Running $0 in $PWD"
su bnbchaind -c "$EXE"
