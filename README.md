# helm_charts
helm charts to deploy frontend apps, backend services to Kubernetes.

# Possible Error and solution
An error occurred while checking for chart dependencies. You may need to run `helm dependency build` to fetch missing dependencies: found in Chart.yaml, but missing in charts/ directory: namespace, gateway, dojima-wallet, internal-docs
Solution- execute `helm dependency build ./frontend-apps`