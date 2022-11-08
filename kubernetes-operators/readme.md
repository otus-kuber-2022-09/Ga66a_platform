Багофикс:
Если контейнер с оператором валит ошибками типа</br>

<code>
kopf.objects         [ERROR   ] [default/mysql-instance] Handler 'mysql_on_create' failed with an exception. Will retry.<br/>
Traceback (most recent call last):<br/>
File "/usr/local/lib/python3.7/site-packages/kopf/_core/actions/execution.py", line 288, in execute_handler_once<br/>
subrefs=subrefs,<br/>
File "/usr/local/lib/python3.7/site-packages/kopf/_core/actions/execution.py", line 382, in invoke_handler<br/>
runtime=runtime,<br/>
File "/usr/local/lib/python3.7/site-packages/kopf/_core/actions/invocation.py", line 139, in invoke<br/>
await asyncio.shield(future)  # slightly expensive: creates tasks<br/>
File "/usr/local/lib/python3.7/concurrent/futures/thread.py", line 57, in run<br/>
result = self.fn(*self.args, **self.kwargs)<br/>
File "/mysql-operator.py", line 52, in mysql_on_create<br/>
'storage_size': storage_size})<br/>
File "/mysql-operator.py", line 12, in render_template<br/>
json_manifest = yaml.load(yaml_manifest)<br/>
TypeError: load() missing 1 required positional argument: 'Loader'<br/>
</code>

Решения: <br/>
0 - Четкое указание версии в Dockerfile <code>pyyaml==5.4.1</code><br/>
1 - Замена <code>json_manifest = yaml.load(yaml_manifest)</code> на <code>json_manifest = yaml.full_load(yaml_manifest)</code> в mysql-operator.py.<br/>
2 - Замена <code>json_manifest = yaml.load(yaml_manifest)</code> на <code>json_manifest = yaml.load(yaml_manifest, Loader=yaml.FullLoader)</code> в mysql-operator.py.<br/>



Результат:
<text>
$ kubectl get jobs<br/>
NAME                         COMPLETIONS   DURATION   AGE<br/>
backup-mysql-instance-job    1/1           4s         4m4s<br/>
restore-mysql-instance-job   1/1           29s        3m3s<br/>
</text>

$ export MYSQLPOD=$(kubectl get pods -l app=mysql-instance -o jsonpath="{.items[*].metadata.name}")<br/>
$ kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "select * from test;" otus-database<br/>
mysql: [Warning] Using a password on the command line interface can be insecure.<br/>
+----+-------------+<br/>
| id | name        |<br/>
+----+-------------+<br/>
|  1 | some data   |<br/>
|  2 | some data-2 |<br/>
|  3 | some data   |<br/>
|  4 | some data-2 |<br/>
+----+-------------+<br/>
