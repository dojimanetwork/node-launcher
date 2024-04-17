# Run a validator node

## System Requirements

The __minimum__ system requirements mean you can run the nodes but the setup is not future-proof.

The __recommended__ system requirements mean the nodes are future-proof. There is, however, no upper limit to future-proofing your nodes.

## Minimum system requirements

- RAM: 16GB
- CPU: 8 core
- Storage: 1 TB SSD

## Recommended system requirements

- RAM: 32GB
- CPU: 16 core
- Storage: 2 TB SSD


## Overview 

To set up a node, you have two choices:
- Set up manually (not recommended unless you are an expert)
- Set up via Kubernetes (recommended)

## Dojima-chain Stack:

- Hermesnode
- Narada
- Narada-eddsa
- DojimaChain


# Cluster Launcher
- GCP
- Aws

# Deploying
Deploying a DojimaChain and its associated services.

Now you have a Kubernetes cluster ready to use, you can install the DojimaChain services.

## Requirements
- Running Kubernetes cluster
- Kubectl configured, ready and connected to running cluster

# Steps
Clone the `dojima-chain-launcher` repo. All commands in this section are to be run inside of this repo.

```
git clone git@github.com:dojimanetwork/dojima-chain-launcher.git
cd dojima-chain-launcher
git checkout master
```

# Install Helm 3
Install Helm 3 if not already available on your current machine:

```
make helm
make helm-plugins
```
# Tools
To deploy all tools, metrics, logs management, Kubernetes Dashboard, run the command below.

```
make tools
```

# Deploy DojimaChain

## Add environment variables.

`Linux`
Add below variables to .bashrc file located at ~/.bashrc or /your_home/.basrhc

```bash
export NET=stagenet
export TYPE=validator
export NAME=hermes-validator
export HERMES_GATEWAY=hermes-gateway
```

Run make command 

```bash
make install
```

# Run manually Using VM instance

On GCP, Launch VM instance with below configuration
VM machine configuration:
machine type: e2-standard-8 ( 8CPU, 32 Gb ram )
Image: Linux, 20.04 LTS version
Disk: 1000 Gib = 1000 GB

```terraform
# This code is compatible with Terraform 4.25.0 and versions that are backward compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "hermes-public-validator" {
  boot_disk {
    auto_delete = true
    device_name = "hermes-public-validator"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b"
      size  = 1000
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-standard-8"
  name         = "hermes-public-validator"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/prod-dojima/regions/asia-south1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "485XXX-compute@developer.gserviceaccount.com" # Replace this with your service account email
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = "asia-south1-c"
}

```

```gcloud
gcloud compute instances create hermes-public-validator --project=prod-dojima \
--zone=asia-south1-c --machine-type=e2-standard-8 \
--network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
--maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=485544309483-compute@developer.gserviceaccount.com \
--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
--create-disk=auto-delete=yes,boot=yes,device-name=hermes-public-validator,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b,mode=rw,size=1000,type=projects/prod-dojima/zones/asia-south1-c/diskTypes/pd-balanced \
--no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any
```

## Necessary Software Installation

### ___keep 4 terminals open to run hermes, narada, narada-eddsa, dojima-chain___

## Running Hermes node

```shell
# install protoc, make, proto-gen-go
1. sudo apt-get update
2. sudo apt-get install build-essential make git jq gcc protobuf-compiler python3-dev python3-pip nano
```

```shell
# install go 1.18 version https://go.dev/dl/go1.18.linux-amd64.tar.gz

1. wget https://go.dev/dl/go1.18.linux-amd64.tar.gz
2. sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz # use sudo based on situation
3. nano ~/.bashrc and copy paste 
`
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin` at bottom of the file.
4. source ~/.bashrc
5. go version should result  `go version go1.18 linux/amd64`
```

```shell
# clone hermes repo:
git clone git@github.com:dojimanetwork/hermes.git
```

```shell
# binary installation
cd hermes
make protob
make install

# verify binaries in the path
ls $HOME/go/bin

# move go binaries from $HOME/go/bin to /usr/bin.
sudo cp $HOME/go/bin/* /usr/bin
```


```shell
# necessary env variables to export before starting hermes
1. sudo nano /etc/default/hermesnode.env
2. copy, paste and assign proper values to variables.
CHAIN_HOME_FOLDER=~/.hermesnode1
DOJ_CHAIN_HOME_FOLDER=~/.dojimachain
SIGNER_NAME=hermestwo
SIGNER_PASSWD=password # any prompt to hermes and dojimachain use this password
BINANCE=localhost
PEER="34.93.113.63,34.93.45.195" # get ip addresses from discord server
SEEDS=$PEER
PORT_RPC=27657
PORT_P2P=27656
PORT_API=1417
PORT_GRPC=9190
PORT_GRPC_WEB=9191
DOJIMA_RPC_URL=http://localhost:8545
ETH_HOST=http://localhost:9545  # not important just declare
CHAIN_ID=hermeschain-stagenet
NET=stagenet
# it's recommended to manually edit the file and add it
SIGNER_SEED_PHRASE="obvious august river model legend pipe little fossil chase chicken good math lake dash wage trim tenant ramp absorb soon network piece boil during" # add your seed phrase

3. sudo nano $HOME/.bashrc
4. copy, paste and assign proper values to variables.
export CHAIN_HOME_FOLDER=~/.hermesnode1
export DOJ_CHAIN_HOME_FOLDER=~/.dojimachain
export SIGNER_NAME=hermestwo
export SIGNER_PASSWD=password # any prompt to hermes and dojimachain use this password
export BINANCE=localhost
export PEER="34.93.113.63" # get ip addresses from discord server
export SEEDS="34.93.113.63,34.93.45.195"
export PORT_RPC=27657
export PORT_P2P=27656
export PORT_API=1417
export PORT_GRPC=9190
export PORT_GRPC_WEB=9191
export DOJIMA_RPC_URL=http://localhost:8545
export ETH_HOST=http://localhost:9545  # not important just declare
export CHAIN_ID=hermeschain-stagenet
export NET=stagenet
# it's recommended to manually edit the file and add it
export SIGNER_SEED_PHRASE="obvious august river model legend pipe little fossil chase chicken good math lake dash wage trim tenant ramp absorb soon network piece boil during" # add your seed phrase

5. source $HOME/.bashrc

```

```shell
# running hermes
cd build/scripts
bash validator.sh
```

```shell
# create hermesnode service
1. execute below command to create hermesnode service file

sudo tee <<EOF >/dev/null /etc/systemd/system/hermesnoded.service
[Unit]
Description=Hermesd Cosmos daemon
After=network-online.target

[Service]
User=$USER
EnvironmentFile=/etc/default/hermesnode.env
ExecStart=/usr/bin/hermesnode start --home $HOME/.hermesnode1 --log_level trace
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

2. cat /etc/systemd/system/hermesnoded.service
3. sudo systemctl enable hermesnoded
4. sudo systemctl daemon-reload
5. sudo systemctl restart hermesnoded
6. check for hermesnode logs:- journalctl -u hermesnoded.service -f -n 100
```

## Running narada

```shell
# create narada service file
1. sudo nano /etc/default/narada.env
2. copy, paste and assign proper values to variables.
PEER="34.93.45.195,34.93.113.63"
CONFIG_PATH=/etc/val-narada
CHAIN_HOME_FOLDER=/path/to/folder/.hermesnode1
SIGNER_NAME=hermestwo
SIGNER_PASSWD=password
DB_PATH=/var/data/val-1-narada
CHAIN_API=127.0.0.1:1317
CHAIN_RPC=127.0.0.1:26657
EXTERNAL_IP=0.0.0.0
TSS_P2P_PORT=5140
P2P_ID_PORT=6140
EDDSA_P2P_PORT=5142
EDDSA_P2P_ID_PORT=6142
EDDSA_HTTP_PORT=6150
EDDSA_HOST=127.0.0.1:6150
CHAIN_ID=hermeschain-stagenet
KEY_PASSPHRASE=$SIGNER_PASSWD
INCLUDE_ETH_CHAIN=true
INCLUDE_BINANCE_CHAIN=false
INCLUDE_BTC_CHAIN=false
INCLUDE_AR_CHAIN=false
INCLUDE_DOT_CHAIN=false
INCLUDE_SOL_CHAIN=false
INCLUDE_GAIA_CHAIN=false
INCLUDE_DOJ_CHAIN=true
INCLUDE_AVAX_CHAIN=false
DOJIMA_SPAN_ENABLE=true
DOJ_CHAIN_ID=1401
AVAX_HOST=https://avax.h4s.dojima.network/ext/bc/C/rpc
DOJIMA_RPC_URL=http://localhost:8545
DOJ_HOST=http://localhost:8545
ETH_START_BLOCK_HEIGHT=0
BTC_HOST=https://btc.h4s.dojima.network
INCLUDE_SOL_CHAIN=false
SOL_START_BLOCK_HEIGHT=0
ETH_SUGGESTED_FEE_VERSION=2
EXTERNAL_IP=10.2.9.84
BINANCE_HOST=https://
DOT_HOST=wss://dotws.h4s.dojima.network
ETH_HOST=https://eth.h4s.dojima.network
DOJ_START_BLOCK_HEIGHT=0
SOL_HOST=ws
BTC_START_BLOCK_HEIGHT=0
DOJIMA_GRPC_URL=hermesnode:9090
BINANCE_START_BLOCK_HEIGHT=0
DOT_START_BLOCK_HEIGHT=0


3. sudo nano $HOME/.bashrc
4. copy, paste and assign proper values to variables.
# export variables
export PEER="34.93.45.195,34.93.113.63"
export CONFIG_PATH=/etc/val-narada
export CHAIN_HOME_FOLDER=$HOME/.hermesnode1
export SIGNER_NAME=hermestwo
export SIGNER_PASSWD=password # any prompt to hermes and dojimachain use this password
export DB_PATH=/var/data/val-1-narada
export CHAIN_API=127.0.0.1:1317
export CHAIN_RPC=127.0.0.1:26657
export EXTERNAL_IP=0.0.0.0
export TSS_P2P_PORT=5140
export P2P_ID_PORT=6140
export EDDSA_P2P_PORT=5142
export EDDSA_P2P_ID_PORT=6142
export EDDSA_HTTP_PORT=6150
export EDDSA_HOST=127.0.0.1:6150
export CHAIN_ID=hermeschain-stagenet
export KEY_PASSPHRASE=$SIGNER_PASSWD
export INCLUDE_ETH_CHAIN=true
export INCLUDE_BINANCE_CHAIN=false
export INCLUDE_BTC_CHAIN=false
export INCLUDE_AR_CHAIN=false
export INCLUDE_DOT_CHAIN=false
export INCLUDE_SOL_CHAIN=false
export INCLUDE_GAIA_CHAIN=false
export INCLUDE_DOJ_CHAIN=true
export INCLUDE_AVAX_CHAIN=false
export DOJIMA_SPAN_ENABLE=true
export DOJ_CHAIN_ID=1401
export AVAX_HOST=https://avax.h4s.dojima.network/ext/bc/C/rpc
export DOJIMA_RPC_URL=http://localhost:8545
export DOJ_HOST=http://localhost:8545
export ETH_START_BLOCK_HEIGHT=0
export BTC_HOST=https://btc.h4s.dojima.network
export INCLUDE_SOL_CHAIN=false
export SOL_START_BLOCK_HEIGHT=0
export ETH_SUGGESTED_FEE_VERSION=2
export EXTERNAL_IP=10.2.9.84
export BINANCE_HOST=https://
export DOT_HOST=wss://dotws.h4s.dojima.network
export ETH_HOST=https://eth.h4s.dojima.network
export DOJ_START_BLOCK_HEIGHT=0
export SOL_HOST=ws
export BTC_START_BLOCK_HEIGHT=0
export DOJIMA_GRPC_URL=hermesnode:9090
export BINANCE_START_BLOCK_HEIGHT=0
export DOT_START_BLOCK_HEIGHT=0
```

```shell
sudo -SE bash narada.sh
```

```shell
# create narada service

sudo tee <<EOF >/dev/null /etc/systemd/system/naradad.service
[Unit]
Description=Naradad service daemon
After=network-online.target

[Service]
User=$USER
EnvironmentFile=/etc/default/narada.env
ExecStart=sudo -SE /usr/bin/narada -c /etc/val-narada/config.json -l debug -t /etc/val-narada/preparam.data
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

2. cat /etc/systemd/system/naradad.service
3. sudo systemctl enable naradad
4. sudo systemctl daemon-reload
5. sudo systemctl restart naradad
6. check for narada logs:- journalctl -u naradad.service -f -n 100
```


## Running narada eddsa

```shell
# create narada-eddsa service

sudo tee <<EOF >/dev/null /etc/systemd/system/narada-eddsad.service
[Unit]
Description=Narada Eddsad service daemon
After=network-online.target

[Service]
User=$USER
EnvironmentFile=/etc/default/narada.env
ExecStart=sudo -SE /usr/bin/tss-eddsa -c /etc/val-narada/eddsa.json -l debug -t /etc/val-narada/preparam.data
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

2. cat /etc/systemd/system/narada-eddsad.service
3. sudo systemctl enable narada-eddsad
4. sudo systemctl daemon-reload
5. sudo systemctl restart narada-eddsad
6. check for narada logs:- journalctl -u narada-eddsad.service -f -n 100
```

## Run Dojima-chain
```shell
# clone dojima chain repo:
1. cd ~
2. git clone git@github.com:dojimanetwork/dojimachain.git
3. cd dojimachain
4. make dc-all
5. sudo cp $HOME/go/bin/* /usr/bin
```

```shell
# init dojimachain 
1. dojimachain init builder/files/mainnet.json --datadir ~/.dojimachain
2. sudo nano /etc/default/dojimachain.env
3. copy, paste and assign proper values to variables.
DOJIMA_RPC_URL=http://localhost:1417
DOJIMA_GRPC_URL=localhost:9190
4. touch $HOME/password.txt
5. echo $SIGNER_PASSWD >> $HOME/password.txt
6. hermesnode eth-ks --home "${CHAIN_HOME_FOLDER}" $CHAIN_HOME_FOLDER $SIGNER_NAME $SIGNER_PASSWD
7. Use the output of above command in --unlock param of dojimachain command in the next step.

```

```shell
# create dojimachain service

sudo tee <<EOF >/dev/null /etc/systemd/system/dojimachaind.service
[Unit]
Description=Dojima Chaind service daemon
After=network-online.target

[Service]
User=$USER
EnvironmentFile=/etc/default/dojima-chain.env
ExecStart=dojimachain --networkid=1401 --port=30303 --syncmode=snap --verbosity=3 --datadir=$HOME/.dojimachain --keystore=$HOME/.dojimachain/data/keystore --mine --unlock=0xA525967A67847EB6d4816762C0d4811FA47F1234 --password=$HOME/password.txt --allow-insecure-unlock --http --http.api=personal,db,eth,net,web3,txpool,miner,admin,dojimachain --http.addr=0.0.0.0 --http.port=8545 --http.corsdomain=* --http.vhosts=* --ws --ws.origins=* --ws.port=8546 --ws.addr=0.0.0.0 --ws.api=personal,eth,web3 --bootnodes=enode://03734b8d2d0b40b0d51297101b82e0d5576f1e2c72890d01060d742d5c6e016edafceaab53658038fa44d52989454d7f9984d22eb2fb1b06be9bcbb23c91e63a@34.93.45.195:30303
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

2. cat /etc/systemd/system/dojimachaind.service
3. sudo systemctl enable dojimachaind
4. sudo systemctl daemon-reload
5. sudo systemctl restart dojimachaind
6. check for narada logs:- journalctl -u dojimachaind.service -f -n 100
```








