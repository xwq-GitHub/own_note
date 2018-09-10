select C.ip,C.tcp_estab from ip I,servertypeconf S,cpuandtcpdata C where S.servertypeid = '1' and S.servertypeid = I.servertypeid and C.ip = I.ip


SELECT
	*
FROM
	ip I,
	cpuandtcpdata C
WHERE
	I.servertypeid = '1'
AND C.ip = I.ip
and zabbixdate = '20180702'