./kind delete cluster
./kind create cluster --config kind-config.yaml  --image kindest/node:v1.21.14
helm install --wait consul consul-helm
helm install --wait vault vault-helm
kubectl exec -it vault-0 -- vault operator init --key-shares=1 --key-threshold=1

#manual
# kubectl exec -it vault-0 -- vault operator init --key-shares=1 --key-threshold=1

# kubectl exec -it vault-0 -- vault operator unseal 'anzvz+2+YnWj+0ffNdnHeAjLXOw7grvg0RtN2PG1A+o='
# kubectl exec -it vault-1 -- vault operator unseal 'anzvz+2+YnWj+0ffNdnHeAjLXOw7grvg0RtN2PG1A+o='
# kubectl exec -it vault-2 -- vault operator unseal 'anzvz+2+YnWj+0ffNdnHeAjLXOw7grvg0RtN2PG1A+o='

# kubectl exec -it vault-0 -- vault secrets enable --path=otus kv
# kubectl exec -it vault-0 -- vault secrets list --detailed
# kubectl exec -it vault-0 -- vault kv put otus/otus-ro/config username='otus' password='asajkjkahs'
# kubectl exec -it vault-0 -- vault kv put otus/otus-rw/config username='otus' password='asajkjkahs'
# kubectl exec -it vault-0 -- vault read otus/otus-ro/config
# kubectl exec -it vault-0 -- vault kv get otus/otus-rw/config

# kubectl exec -it vault-0 -- vault auth enable kubernetes
# kubectl exec -it vault-0 -- vault auth list

# kubectl create serviceaccount vault-auth
# kubectl apply -f vault-auth-service-account.yml

# export VAULT_SA_NAME=$(kubectl get sa vault-auth -o jsonpath="{.secrets[*]['name']}")
# export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode)
# export SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode)
# export K8S_HOST=$(more ~/.kube/config | grep server |awk '/http/ {print $NF}')
########
#Old
# kubectl exec -it vault-0 -- vault write auth/kubernetes/config  token_reviewer_jwt="$SA_JWT_TOKEN"  kubernetes_host="$K8S_HOST" kubernetes_ca_cert="$SA_CA_CRT"
#New https://172.18.0.5:6443/
#kubectl exec -it vault-0 -- vault write auth/kubernetes/config  token_reviewer_jwt="$SA_JWT_TOKEN"  kubernetes_host="https://172.18.0.5:6443/" kubernetes_ca_cert="$SA_CA_CRT"
########

# kubectl cp otus-policy.hcl vault-0:/tmp/
# kubectl exec -it vault-0 -- vault policy write otus-policy /tmp/otus-policy.hcl
# kubectl exec -it vault-0 -- vault write auth/kubernetes/role/otus bound_service_account_names=vault-auth  bound_service_account_namespaces=default policies=otus-policy ttl=24h

# kubectl run tmp --rm -i --tty --overrides='{ "spec": { "serviceAccount": "vault-auth" }  }' --image alpine:3.7
# apk add curl jq
# VAULT_ADDR=http://vault:8200
# KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
# curl --request POST --data '{"jwt": "'$KUBE_TOKEN'", "role": "otus"}' $VAULT_ADDR/v1/auth/kubernetes/login | jq
# TOKEN=$(curl -k -s --request POST --data '{"jwt": "'$KUBE_TOKEN'", "role": "otus"}' $VAULT_ADDR/v1/auth/kubernetes/login | jq '.auth.client_token' | awk -F\" '{print $2}')

# curl --header "X-Vault-Token:$TOKEN" $VAULT_ADDR/v1/otus/otus-ro/config
# curl --header "X-Vault-Token:$TOKEN" $VAULT_ADDR/v1/otus/otus-rw/config

# curl --request POST --data '{"bar": "baz"}' --header "X-VaultToken:$TOKEN" $VAULT_ADDR/v1/otus/otus-ro/config
# curl --request POST --data '{"bar": "baz"}' --header "X-VaultToken:$TOKEN" $VAULT_ADDR/v1/otus/otus-rw/config

# kubectl apply -f configmap.yaml
# kubectl apply -f example-k8s-spec.yaml --record

# kubectl exec -it vault-0 -- vault secrets enable pki
# kubectl exec -it vault-0 -- vault secrets tune -max-lease-ttl=87600h pki
# kubectl exec -it vault-0 -- vault write -field=certificate pki/root/generate/internal common_name="examaple.ru" ttl=87600h > CA_cert.crt

# kubectl exec -it vault-0 -- vault write pki/config/urls issuing_certificates="http://vault:8200/v1/pki/ca" crl_distribution_points="http://vault:8200/v1/pki/crl"

# kubectl exec -it vault-0 -- vault secrets enable --path=pki_int pki
# kubectl exec -it vault-0 -- vault secrets tune -max-lease-ttl=87600h pki_int
# kubectl exec -it vault-0 -- vault write -format=json pki_int/intermediate/generate/internal  common_name="example.ru Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr

# kubectl cp pki_intermediate.csr vault-0:/tmp/
# kubectl exec -it vault-0 -- vault write -format=json pki/root/sign-intermediate  csr=@/tmp/pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem
# kubectl cp intermediate.cert.pem vault-0:/tmp/
# kubectl exec -it vault-0 -- vault write pki_int/intermediate/set-signed  certificate=@/tmp/intermediate.cert.pem

# kubectl exec -it vault-0 -- vault write pki_int/roles/example-dot-ru allowed_domains="example.ru" allow_subdomains=true max_ttl="720h"
# kubectl exec -it vault-0 -- vault write pki_int/issue/example-dot-ru common_name="test.example.ru" ttl="24h"

https://github.com/otus-kuber-2022-09/Ga66a_platform/pull/11