./kind delete cluster
#./kind create cluster --config kind-config.yaml --image kindest/node:v1.21.14
./kind create cluster --config kind-config.yaml
kubectl config use-context kind-kind

