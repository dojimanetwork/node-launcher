INGRESS_HOST=${INGRESS_HOST:="$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"}
INGRESS_PORT=${INGRESS_PORT:="export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')"}
APP_NAME=${APP_NAME:="dojima-wallet"}
echo “http://$INGRESS_HOST:$INGRESS_PORT/${APP_NAME}”