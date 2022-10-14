./kind delete cluster
./kind create cluster --config kind-config.yaml
./kubectl apply -f minio-statefulset.yaml
./kubectl apply -f minio-headless-service.yaml
./kubectl apply -f minio-secrets.yaml