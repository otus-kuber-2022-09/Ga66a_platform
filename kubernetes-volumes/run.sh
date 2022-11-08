./kind delete cluster

./kind create cluster --config kind-config.yaml

./kubectl apply -f minio-statefulset.yaml

./kubectl apply -f minio-headless-service.yaml

./kubectl apply -f minio-secrets.yaml

./kubectl wait --for=condition=Ready pod/minio-0 --timeout=300s

sleep 10

./kubectl run -i --tty --rm debug --image=otusplatform/test-minio --restart=Never