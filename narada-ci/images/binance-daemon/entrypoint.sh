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
  sed -i -e "s/seeds =.*/seeds = \"aea74b16d28d06cbfbb1179c177e8cd71315cce4@tcp://0.0.0.0:27146,34ac6eb6cd914014995b5929be8d7bc9c16f724d@aa13359cd244f11e988520ad55ba7f5a-c3963b80c9b991b7.elb.us-east-1.amazonaws.com:27146,34ac6eb6cd914014995b5929be8d7bc9c16f724d@aa13359cd244f11e988520ad55ba7f5a-c3963b80c9b991b7.elb.us-east-1.amazonaws.com:27146\"/g" "${BNCHOME}/config/config.toml"
fi

echo "Running $0 in $PWD"
su bnbchaind -c "$EXE"
