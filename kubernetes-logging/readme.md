NAME: elasticsearch
LAST DEPLOYED: Mon Oct 31 14:53:49 2022
NAMESPACE: observability
STATUS: deployed
REVISION: 1
NOTES:
1. Watch all cluster members come up.
  $ kubectl get pods --namespace=observability -l app=elasticsearch-master -w
2. Retrieve elastic user's password.
  $ kubectl get secrets --namespace=observability elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d
3. Test cluster health using Helm test.
  $ helm --namespace=observability test elasticsearch


NAME: kibana
LAST DEPLOYED: Mon Oct 31 14:54:59 2022
NAMESPACE: observability
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Watch all containers come up.
  $ kubectl get pods --namespace=observability -l release=kibana -w
2. Retrieve the elastic user's password.
  $ kubectl get secrets --namespace=observability elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d


WARNING: This chart is deprecated
NAME: fluent-bit
LAST DEPLOYED: Mon Oct 31 14:59:26 2022
NAMESPACE: observability
STATUS: deployed
REVISION: 1
NOTES:
fluent-bit is now running.

It will forward all container logs to the svc named fluentd on port: 24284
