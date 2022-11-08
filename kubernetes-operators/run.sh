docker build -t mysql-operator ./build
docker tag mysql-operator ga66a/mysql-operator
docker push ga66a/mysql-operator

./kind delete cluster
./kind create cluster --config kind-config.yaml #--image kindest/node:v1.21.14
./kubectl config use-context kind-kind
./kubectl apply -f deploy/service-account.yaml
./kubectl apply -f deploy/role.yaml
./kubectl apply -f deploy/role-binding.yaml
./kubectl apply -f deploy/deploy-operator.yaml
./kubectl apply -f deploy/crd.yaml
./kubectl apply -f deploy/cr.yaml