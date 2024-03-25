# Run a validator node

## System Requirements

The __minimum__ system requirements mean you can run the nodes but the setup is not future-proof.

The __recommended__ system requirements mean the nodes are future-proof. There is, however, no upper limit to future-proofing your nodes.

## Minimum system requirements

- RAM: 4GB
- CPU: 4 core
- Storage: 1 TB SSD

## Recommended system requirements

- RAM: 16GB
- CPU: 8 core
- Storage: 1 TB SSD


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
