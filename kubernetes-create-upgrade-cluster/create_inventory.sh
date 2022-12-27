cd cloud-terraform
rm ../inventory/inventory.ini
touch ../inventory/inventory.ini
echo "[all]" >> ../inventory/inventory.ini
echo "master-0 ansible_host=$(terraform output -raw external_ip_address_master-0) etcd_member_name=etcd0" >> ../inventory/inventory.ini
echo "master-1 ansible_host=$(terraform output -raw external_ip_address_master-1) etcd_member_name=etcd1" >> ../inventory/inventory.ini
echo "master-2 ansible_host=$(terraform output -raw external_ip_address_master-2) etcd_member_name=etcd2" >> ../inventory/inventory.ini
echo "worker-0 ansible_host=$(terraform output -raw external_ip_address_worker-0)" >> ../inventory/inventory.ini
echo "worker-1 ansible_host=$(terraform output -raw external_ip_address_worker-1)" >> ../inventory/inventory.ini
echo "worker-2 ansible_host=$(terraform output -raw external_ip_address_worker-2)" >> ../inventory/inventory.ini
cat <<EOT >> ../inventory/inventory.ini

[kube_control_plane]
master-0
master-1
master-2

[etcd]
master-0
master-1
master-2

[kube_node]
worker-0
worker-1
worker-2

[k8s_cluster:children]
kube_control_plane
kube_node
EOT
