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
    email  = "485544309483-compute@developer.gserviceaccount.com"
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
sudo apt-get install build-essential make git
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

``` shell
# install protoc, make, proto-gen-go
1. sudo apt-get update
2. sudo apt-get install build-essential make git jq gcc protobuf-compiler python3-dev python3-pip
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
```


```shell
# necesary env variables to export before starting hermes
export CHAIN_HOME_FOLDER=~/.hermesnode1
export SIGNER_NAME=hermestwo
export SIGNER_SEED_PHRASE="" # add your seed phrase
export SIGNER_PASSWD= # any prompt to hermes and dojimachain use this password
export BINANCE=localhost
export PEER= # get ip addresses from discord server
export SEEDS=$PEER
export PORT_RPC=27657
export PORT_P2P=27656
export PORT_API=1417
export PORT_GRPC=9190
export PORT_GRPC_WEB=9191
export DOJIMA_RPC_URL=http://localhost:8545
export ETH_HOST=http://localhost:9545 # not important just declare
export CHAIN_ID=hermeschain-stagenet
export NET=stagenet
```

```shell
# running hermes
cd build/scripts
sh validator.sh && echo $SIGNER_PASSWD | hermesnode start --home ~/.hermesnode1 --log_level trace
```







