На мастерноде:
git clone https://github.com/kubernetes-csi/csi-driver-host-path.git
cd csi-driver-host-path/deploy/kubernetes-1.25

kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml

./deploy.sh

Имеем
$ k get po
NAME                   READY   STATUS    RESTARTS   AGE
csi-hostpath-socat-0   1/1     Running   0          23s
csi-hostpathplugin-0   8/8     Running   0          24s

в репке
kubectl apply -f csi-storageclass.yaml
kubectl apply -f storage-pvc.yaml

Имеем:
$ k get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                 STORAGECLASS      REASON   AGE
pvc-ef2b98aa-89ad-48cb-9436-8cf80fe73320   1Gi        RWO            Delete           Bound    default/storage-pvc   csi-hostpath-sc            13s

$ k get pvc
NAME          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
storage-pvc   Bound    pvc-ef2b98aa-89ad-48cb-9436-8cf80fe73320   1Gi        RWO            csi-hostpath-sc   34s


Добавим POD.
k apply -f storage-pod.yaml

Имеем:
$ k describe po storage-pod
...
Mounts:
/data from vol (rw)
/var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-gf2t4 (ro)
Conditions:
Type              Status
Initialized       True
Ready             True
ContainersReady   True
PodScheduled      True
Volumes:
vol:
Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
ClaimName:  storage-pvc
ReadOnly:   false
kube-api-access-gf2t4:
Type:                    Projected (a volume that contains injected data from multiple sources)
TokenExpirationSeconds:  3607
ConfigMapName:           kube-root-ca.crt
ConfigMapOptional:       <nil>
DownwardAPI:             true
...




Хороший мануал
https://docs.trilio.io/kubernetes/v/2.1.0/appendix/csi-drivers/hostpath-for-tvk