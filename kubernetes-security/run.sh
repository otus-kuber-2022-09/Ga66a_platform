./kind delete cluster
./kind create cluster --config kind-config.yaml
./kubectl apply -f ./task01/01-serviceaccount-bob.yaml
./kubectl apply -f ./task01/02-clusterRoleBinding.yaml
./kubectl apply -f ./task01/03-serviceaccount-dave.yaml

./kubectl apply -f ./task02/01-namespace.yaml
./kubectl apply -f ./task02/02-serviceaccount-carol.yaml
./kubectl apply -f ./task02/03-role.yaml
./kubectl apply -f ./task02/04-rolebinding.yaml


