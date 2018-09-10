```
mysqlbinlog -v --base64-output=decode-rows --start-datetime='2018-04-19 04:00:00' --stop-date='2018-04-19 04:15:00' mysql-bin.000072 > /tmp/0419_3.sql
```