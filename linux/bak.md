## re_update_qd
```
graph TD
A[sh shutdown.sh]-->B[tar webapps]
B-->C[unzip updatefile]
X-->D[rsync bakupfile to 139]
C-->E{rm works/*}
E-->|master_node|X[sh startup.sh]
E-->|salve_node|Y[sh false_startup.sh]
```
## nore_update_qd

```
graph TD

A[tar webapps]-->B[unzip updatefile]
B-->C[rsync bakupfile to 139]

```

## re_update_jfpt

```
graph TD
A[sh shutdown.sh]-->B[tar webapps]
B-->C[unzip updatefile]
X-->D[rsync bakupfile to 139]
C-->E{rm works/*}
E-->|master_node|X[sh startup.sh]
E-->|salve_node|Y[sh false_startup.sh]
```

## nore_update_jfpt

```
graph TD

A[tar webapps]-->B[unzip updatefile]
B-->C[rsync bakupfile to 139]

```

