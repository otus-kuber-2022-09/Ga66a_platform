./kind delete cluster
./kind create cluster --config kind-config.yaml --image kindest/node:v1.21.14
#./kind create cluster --config kind-config.yaml
kubectl config use-context kind-kind
#kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
#kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml