./kind delete cluster
./kind create cluster --config kind-config.yaml
kubectl config use-context kind-kind
#helm repo add bitnami https://charts.bitnami.com/bitnami
#helm repo update
./kubectl create ns monitoring
helm upgrade --install kube-prometheus --namespace=monitoring bitnami/kube-prometheus
./kubectl create ns nginx-test
helm upgrade --install nginx -nnginx-test bitnami/nginx -f nginx.values.yaml
helm upgrade --install grafana -nmonitoring bitnami/grafana

#./kubectl  apply -nnginx-test -f nginx.configmap.yaml
#./kubectl  apply -nnginx-test -f nginx.deployment.yaml
#./kubectl  apply -nnginx-test -f nginx.service.yaml
#./kubectl  apply -nnginx-test -f nginx.exporter.yaml
#./kubectl apply -nnginx-test -f nginx.servicemonitor.yaml

