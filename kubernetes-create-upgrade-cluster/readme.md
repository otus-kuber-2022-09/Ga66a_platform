Поднятие кластера kubernetes с использованием terraform и kubespray в контейнере.
Подключение terraform к YC
https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart
Зеркало бинарников terraform
https://hashicorp-releases.yandexcloud.net/terraform/
Полезное описание
https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance#core_fraction

Загрузочный образ делал свой. Т.к. на дефолтном (ubuntu_22.04) 5GiB места под /, чего явно недостаточно.
Делается очень просто:
    - поднимаем терраформом виртуалку
    - гасим её
    - резайзим винт
    - стартуем
    - проверяем, что / расширился до необходимого размера
    - гасим, снимаем образ, запоминаем ID
    - в main.tf прописываем новый образ

export YC_TOKEN=$(yc iam create-token) \
export YC_CLOUD_ID=$(yc config get cloud-id) \
export YC_FOLDER_ID=$(yc config get folder-id) 

terraform validate
terraform apply

Заполняем инвентори
./create_inventory.sh

Создаем образ контейнера с инвентори и ключом. Можно конечно и примонтировать, но на винде показалось так проще. 
docker build -t kubespray .

Логинимся в контейнер
docker run -it --rm kubespray

Гоним плейбуки
ansible-playbook -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa --become --become-user=root -e kube_version=v1.22.0 --user=k8s cluster.yml

В итоге имеем:
PLAY RECAP ********************************************************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
master-0                   : ok=693  changed=66   unreachable=0    failed=0    skipped=1257 rescued=0    ignored=8
master-1                   : ok=602  changed=58   unreachable=0    failed=0    skipped=1097 rescued=0    ignored=3
master-2                   : ok=604  changed=59   unreachable=0    failed=0    skipped=1095 rescued=0    ignored=3
worker-0                   : ok=465  changed=34   unreachable=0    failed=0    skipped=752  rescued=0    ignored=2
worker-1                   : ok=465  changed=34   unreachable=0    failed=0    skipped=751  rescued=0    ignored=2
worker-2                   : ok=465  changed=34   unreachable=0    failed=0    skipped=751  rescued=0    ignored=2
Tuesday 27 December 2022  05:41:11 +0000 (0:00:00.162)       0:23:28.615 ******

Проверяем кластер
k8s@master-0:~$ kubectl get no
NAME       STATUS   ROLES                  AGE     VERSION
master-0   Ready    control-plane,master   10m     v1.22.0
master-1   Ready    control-plane,master   9m36s   v1.22.0
master-2   Ready    control-plane,master   9m24s   v1.22.0
worker-0   Ready    <none>                 7m59s   v1.22.0
worker-1   Ready    <none>                 7m59s   v1.22.0
worker-2   Ready    <none>                 7m59s   v1.22.0

Деплоим nginx
kubectl apply -f deployment-nginx.yaml

Проверяем
kubectl get po
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-6c74bfd64-9qt69   1/1     Running   0          15s
nginx-deployment-6c74bfd64-jfr9m   1/1     Running   0          15s
nginx-deployment-6c74bfd64-kk5ch   1/1     Running   0          15s
nginx-deployment-6c74bfd64-ktkr7   1/1     Running   0          15s
nginx-deployment-6c74bfd64-lg2dp   1/1     Running   0          15s
nginx-deployment-6c74bfd64-mmndt   1/1     Running   0          15s
nginx-deployment-6c74bfd64-nbbz4   1/1     Running   0          15s
nginx-deployment-6c74bfd64-rg26f   1/1     Running   0          15s
nginx-deployment-6c74bfd64-s46sm   1/1     Running   0          15s
nginx-deployment-6c74bfd64-z9gbg   1/1     Running   0          15s


Обновляем версию кластера.
ansible-playbook -b -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa --become --become-user=root -e kube_version=v1.23.0 --user=k8s upgrade-cluster.yml

В процессе обновления
Every 2.0s: kubectl get no                                                                                                                                                                                                                   master-0: Tue Dec 27 06:27:01 2022
NAME       STATUS                     ROLES                  AGE   VERSION
master-0   Ready                      control-plane,master   52m   v1.23.0
master-1   Ready                      control-plane,master   52m   v1.23.0
master-2   Ready,SchedulingDisabled   control-plane,master   52m   v1.23.0
worker-0   Ready                      <none>                 50m   v1.22.0
worker-1   Ready                      <none>                 50m   v1.22.0
worker-2   Ready                      <none>                 50m   v1.22.0

По итогу имеем:
Every 2.0s: kubectl get no && kubectl get po                                                        master-0: Tue Dec 27 06:40:36 2022

NAME       STATUS   ROLES                  AGE   VERSION
master-0   Ready    control-plane,master   66m   v1.23.0
master-1   Ready    control-plane,master   65m   v1.23.0
master-2   Ready    control-plane,master   65m   v1.23.0
worker-0   Ready    <none>                 64m   v1.23.0
worker-1   Ready    <none>                 64m   v1.23.0
worker-2   Ready    <none>                 64m   v1.23.0
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-6c74bfd64-5q7h5   1/1     Running   0          6m25s
nginx-deployment-6c74bfd64-bzc4s   1/1     Running   0          3m8s
nginx-deployment-6c74bfd64-cnm4q   1/1     Running   0          6m26s
nginx-deployment-6c74bfd64-cq4p6   1/1     Running   0          3m9s
nginx-deployment-6c74bfd64-csp8q   1/1     Running   0          6m25s
nginx-deployment-6c74bfd64-cxw4t   1/1     Running   0          3m7s
nginx-deployment-6c74bfd64-kkcpx   1/1     Running   0          3m9s
nginx-deployment-6c74bfd64-n5dwj   1/1     Running   0          3m8s
nginx-deployment-6c74bfd64-nb7hc   1/1     Running   0          6m26s
nginx-deployment-6c74bfd64-qprtn   1/1     Running   0          6m26s


Не забываем:
terraform destroy