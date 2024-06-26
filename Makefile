SHELL := /bin/bash

help: ## Help message
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

helm: ## Install Helm 3 dependency
	@./scripts/install-helm.sh

helm-plugins: ## Install Helm plugins
	@helm plugin install https://github.com/databus23/helm-diff

repos: ## Add Helm repositories for dependencies
	@echo "=> Installing Helm repos"
	@helm repo add grafana https://grafana.github.io/helm-charts
	@helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo update
	@echo

tools: install-prometheus install-loki install-metrics install-dashboard ## Intall/Update Prometheus/Grafana, Loki, Metrics Server, Kubernetes dashboard

pull: ## Git pull node-launcher repository
	@git clean -idf
	@git pull origin $(shell git rev-parse --abbrev-ref HEAD)

update-dependencies:
	@echo "=> Updating Helm chart dependencies"
	@helm dependencies update ./hermes-stack
	@echo

update-frontend-deps:
	@echo "=> Updating frontend helm chart deps"
	@helm dependencies update ./frontend-apps
	@echo

update-backend-deps:
	@echo "=> Updating backtend helm chart deps"
	@helm dependencies update ./backend-apps
	@echo

update-trust-state: ## Updates statesync trusted height/hash and Midgard blockstore hashes from Nine Realms
	@./scripts/update-trust-state.sh

mnemonic: ## Retrieve and display current mnemonic for backup from your hermesnode
	@./scripts/mnemonic.sh

password: ## Retrieve and display current password for backup from your Hermesnode
	@./scripts/password.sh

pods: ## Get Hermesnodes Kubernetes pods
	@./scripts/pods.sh

install: pull update-dependencies ## Deploy a Hermesnode
	@./scripts/install.sh

install-frontend: pull update-frontend-deps
	@./scripts/frontend-install.sh

install-backend: pull update-backend-deps
	@./scripts/backend-install.sh

recycle: pull update-dependencies ## Destroy and recreate a Hermesnode recycling existing daemons to avoid re-sync
	@./scripts/recycle.sh

update: pull update-dependencies ## Update a Hermesnode to latest version
	@./scripts/update.sh

status: ## Display current status of your Hermesnode
	@./scripts/status.sh

reset: ## Reset and resync a service from scratch on your Hermesnode. This command can take a while to sync back to 100%.
	@./scripts/reset.sh

hard-reset-hermesnode: ## Hard reset and resync hermesnode service from scratch on your HermesNode, leaving no bak/* files.
	@./scripts/hard-reset-hermesnode.sh

backup: ## Backup specific files from either hermesnode of narada service of a hermesnode.
	@./scripts/backup.sh

data-backup:
	@./scripts/data-backup.sh

full-backup: ## Create volume snapshots and backups for both hermesnode and narada services.
	@./scripts/full-backup.sh

restore-backup: ## Restore backup specific files from either hermesnode of bifrost service of a HermesNode.
	@./scripts/restore-backup.sh

snapshot: ## Snapshot a volume for a specific HermesNode service.
	@./scripts/snapshot.sh

restore-snapshot: ## Restore a volume for a specific Hermesnode service from a snapshot.
	@./scripts/restore-snapshot.sh

wait-ready: ## Wait for all pods to be in Ready state
	@./scripts/wait-ready.sh

destroy: ## Uninstall current Hermesnode
	@./scripts/destroy.sh

export-state: ## Export chain state
	@./scripts/export-state.sh

export-state-hold: ## Used in special conditions
	@./scripts/export-state-hold.sh

export-dojima-state:
	@./scripts/export-dojima-state.sh

hard-fork: ## Hard fork chain
	@HARDFORK_BLOCK_HEIGHT=426971 NEW_GENESIS_TIME='2024-03-10T02:29:46.120665Z' CHAIN_ID='hermeschain-stagenet' VIA_URL=true HARDFORK_URL=https://storage.googleapis.com/hermes-node-hard-fork/stagenet/genesis.426971.3.json IMAGE='asia-south1-docker.pkg.dev/prod-dojima/stagenet/hermes:cd65acde_5.4.17' ./scripts/hard-fork.sh

hard-fork-testnet: ## hard fork testnet
	@HARDFORK_BLOCK_HEIGHT=126728 NEW_GENESIS_TIME='2024-02-27T16:11:56.916227472Z' CHAIN_ID='hermes-testnet-v2' VIA_URL=true HARDFORK_URL=https://storage.googleapis.com/hermes-node-hard-fork/testnet/genesis_126728.json IMAGE='asia-south1-docker.pkg.dev/prod-dojima/testnet/hermes:ba90ad4a_5.4.5' ./scripts/hard-fork.sh

hard-fork-testnet-hold: ## hard fork testnet
	@HARDFORK_BLOCK_HEIGHT=126728 NEW_GENESIS_TIME='2024-02-27T16:11:56.916227472Z' CHAIN_ID='hermes-testnet-v2' VIA_URL=true HARDFORK_URL=https://storage.googleapis.com/hermes-node-hard-fork/testnet/genesis_126728.json IMAGE='asia-south1-docker.pkg.dev/prod-dojima/testnet/hermes:ba90ad4a_5.4.5' ./scripts/hard-fork-hold.sh

shell: ## Open a shell for a selected Hermesnode service
	@./scripts/shell.sh

debug: ## Open a shell for Hermesnode service mounting volume to debug
	@./scripts/debug.sh

restore-external-snapshot: ## Restore Hermesnode from external snapshot.
	@./scripts/restore-external-snapshot.sh

recover-binance:
	@./scripts/recover-binance.sh

recover-ninerealms:
	@./scripts/recover-ninerealms.sh

watch: ## Watch the Hermesnode pods in real time
	@./scripts/watch.sh

logs: ## Display logs for a selected Hermesnode service
	@./scripts/logs.sh

restart: ## Restart a selected Hermesnode service
	@./scripts/restart.sh

halt: ## Halt a selected Hermesnode service
	@./scripts/halt.sh

set-node-keys: ## Send a set-node-keys transaction to your Hermesnode
	@./scripts/set-node-keys.sh

set-version: ## Send a set-version transaction to your Hermesnode
	@./scripts/set-version.sh

set-ip-address: ## Send a set-ip-address transaction to your Hermesnode
	@./scripts/set-ip-address.sh

relay: ## Send a message that is relayed to a public Discord channel
	@./scripts/relay.sh

mimir: ## Send a mimir command to set a key/value
	@./scripts/mimir.sh

ban: ## Send a ban command with a node address
	@./scripts/ban.sh

pause: ## Send a pause-chain transaction to your Hermesnode
	@./scripts/pause.sh

resume: ## Send a resume-chain transaction to your Hermesnode
	@./scripts/resume.sh

telegram-bot: ## Deploy Telegram bot to monitor Hermesnode
	@./scripts/telegram-bot.sh

destroy-telegram-bot: ## Uninstall Telegram bot to monitor Hermesnode
	@./scripts/destroy-telegram-bot.sh

destroy-tools: destroy-prometheus destroy-loki destroy-dashboard ## Uninstall Prometheus/Grafana, Loki, Kubernetes dashboard

install-loki: repos ## Install/Update Loki logs management stack
	@./scripts/install-loki.sh

destroy-loki: ## Uninstall Loki logs management stack
	@./scripts/destroy-loki.sh

install-prometheus: repos ## Install/Update Prometheus/Grafana stack
	@./scripts/install-prometheus.sh

destroy-prometheus: ## Uninstall Prometheus/Grafana stack
	@./scripts/destroy-prometheus.sh

install-metrics: repos ## Install/Update Metrics Server
	@echo "=> Installing Metrics"
	@kubectl get svc -A | grep -q metrics-server || kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
	@echo

destroy-metrics: ## Uninstall Metrics Server
	@echo "=> Deleting Metrics"
	@kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
	@echo

install-dashboard: repos ## Install/Update Kubernetes dashboard
	@echo "=> Installing Kubernetes Dashboard"
	@helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -n kube-system --wait -f ./kubernetes-dashboard/values.yaml
	@kubectl apply -f ./kubernetes-dashboard/dashboard-admin.yaml
	@echo

destroy-dashboard: ## Uninstall Kubernetes dashboard
	@echo "=> Deleting Kubernetes Dashboard"
	@helm delete kubernetes-dashboard -n kube-system
	@echo

install-provider: ## Install dojima-chain provider
	@scripts/install-provider.sh

destroy-provider: ## Uninstall dojima-chain provider
	@scripts/destroy-provider.sh

grafana: ## Access Grafana UI through port-forward locally
	@echo User: admin
	@echo Password: thorchain
	@echo Open your browser at http://localhost:3000
	@kubectl -n prometheus-system port-forward service/prometheus-grafana 3000:80

prometheus: ## Access Prometheus UI through port-forward locally
	@echo Open your browser at http://localhost:9090
	@kubectl -n prometheus-system port-forward service/prometheus-kube-prometheus-prometheus 9090

alert-manager: ## Access Alert-Manager UI through port-forward locally
	@echo Open your browser at http://localhost:9093
	@kubectl -n prometheus-system port-forward service/prometheus-kube-prometheus-alertmanager 9093

dashboard: ## Access Kubernetes Dashboard UI through port-forward locally
	@echo Open your browser at http://localhost:8000
	@kubectl -n kube-system port-forward service/kubernetes-dashboard 8000:443

lint: ## Run linters (development)
	./scripts/lint.sh

.PHONY: help helm repo pull tools install-loki install-prometheus install-metrics install-dashboard export-state hard-fork destroy-tools destroy-loki destroy-prometheus destroy-metrics prometheus grafana dashboard alert-manager mnemonic update-dependencies reset restart pods deploy update destroy status shell watch logs set-node-keys set-ip-address set-version pause resume telegram-bot destroy-telegram-bot lint

.EXPORT_ALL_VARIABLES:
