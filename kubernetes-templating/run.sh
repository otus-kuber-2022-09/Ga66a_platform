./kind delete cluster

./kind create cluster --config kind-config.yaml

helm repo add stable https://charts.helm.sh/stable

./kubectl create ns nginx-ingress

helm upgrade --install nginx-ingress stable/nginx-ingress --wait  --namespace=nginx-ingress  --version=1.41.3

./kubectl apply -f cert-manager.crds.yaml