./kind delete cluster
./kind create cluster --config kind-config.yaml #--image kindest/node:v1.21.14
./kubectl config use-context kind-kind


helm repo add fluxcd https://charts.fluxcd.io
helm repo update
#kubectl apply -f https://raw.githubusercontent.com/fluxcd/flux/helm-0.10.1/deploy-helm/flux-helm-release-crd.yaml

helm install flux --namespace flux --wait fluxcd/flux \
  --set git.email="gabba@ga66a.ru" \
  --set git.url=git@github.com:ruzickap/k8s-flux-repository \
  --set git.user="Flux" \
  --set helmOperator.create=true \
  --set helmOperator.createCRD=true \
  --set registry.pollInterval="120s" \
  --set syncGarbageCollection.enabled=true

#  --set registry.insecureHosts="harbor.${MY_DOMAIN}" \

