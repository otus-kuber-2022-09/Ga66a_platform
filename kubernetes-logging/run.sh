./kind delete cluster
./kind create cluster --config kind-config.yaml
./kubectl config use-context kind-kind
#./kubectl create ns observability
#helm upgrade --install elasticsearch helm-charts-elastic/elasticsearch -n observability -f elasticsearch.values.yaml
#helm upgrade --install kibana helm-charts-elastic/kibana -n observability -f kibana.values.yaml
#helm upgrade --install fluent-bit stable/fluent-bit -n observability -f fluentbit.values.yaml



