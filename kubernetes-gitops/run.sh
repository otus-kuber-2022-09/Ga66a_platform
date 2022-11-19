###Local
./kind delete cluster
./kind create cluster --config kind-config.yaml --image kindest/node:v1.21.14
kubectl config use-context kind-kind
###/local

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add fluxcd https://charts.fluxcd.io
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo add flagger https://flagger.app
helm repo update

#MetaLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=90s
kubectl apply -f https://kind.sigs.k8s.io/examples/loadbalancer/metallb-config.yaml
#/MetaLB

helm upgrade --create-namespace --install istio-base istio/base -n istio-system --wait
helm upgrade --create-namespace --install istiod istio/istiod -n istio-system --wait
helm upgrade --create-namespace --install istio-ingress istio/gateway -n istio-ingress --wait
helm upgrade --install prometheus prometheus-community/prometheus --wait

kubectl apply -f https://raw.githubusercontent.com/weaveworks/flagger/master/artifacts/flagger/crd.yaml
kubectl apply -f https://raw.githubusercontent.com/stefanprodan/appmesh-dev/master/flux/flux-helm-release-crd.yaml

helm upgrade --create-namespace --install flux fluxcd/flux -f flux.values.yaml --namespace flux --wait
helm upgrade --create-namespace --install helm-operator fluxcd/helm-operator -f helm-operator.values.yaml --namespace flux --wait

helm upgrade --install -n istio-system -f flagger.values.yaml flagger flagger/flagger --wait


kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2

