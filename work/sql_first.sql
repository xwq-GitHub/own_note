-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- nginx请求方面：
-- 在nginx_log库查询
/*本周内共享扫码付总请求*/SELECT '扫码付总请求',SUM(total_requests) from total_requests where serverid = 1 AND nginxdate BETWEEN '20180718' and '20180724' ;/*次，*/
/*日均接收请求*/ SELECT '日均接收请求',AVG(total_requests) from total_requests where serverid = 1 AND nginxdate BETWEEN '20180718' and '20180724' ; /*次。*/

/*其中请求最多的为 */SELECT '请求最多',nginxdate FROM total_requests WHERE total_requests = ( SELECT MAX(total_requests) FROM total_requests 
	WHERE serverid = 1 AND nginxdate BETWEEN '20180718' AND '20180724' ) AND serverid = 1 AND nginxdate BETWEEN '20180718' AND '20180724' LIMIT 1; /*。 */
/*共接受请求 */SELECT '共接受请求',MAX(total_requests) from total_requests where serverid = 1 AND nginxdate BETWEEN '20180718' and '20180724' ;/* 次。*/

/*单小时并发请求最多时刻为*/SELECT '并发最多时间',nginxdate, nginxtime as aa,'~',nginxtime+1 as bb FROM visitor WHERE hits = 
( SELECT max(hits) FROM visitor WHERE serverid = 1 AND nginxdate BETWEEN '20180718' AND '20180724' ) AND serverid = 1 AND nginxdate BETWEEN '20180718' AND '20180724' LIMIT 1; -- ，
/*共接受请求 */SELECT '请求量',max(hits) FROM visitor WHERE serverid = 1 AND nginxdate BETWEEN '20180718' AND '20180724' ; --  次。
/*由此数据计算，平均并发最高为*/SELECT '并发',max(hits)/3600/27 FROM visitor WHERE serverid = 1 AND nginxdate BETWEEN '20180718' AND '20180724' ;  -- 次/秒·节点 。

-- 详细情况见附件一。


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 商户及交易方面：
-- 需要手动统计
-- 本周共享扫码付共增加商户 0 户。
-- 截止至07月24日共有商户 225065户。
-- 其中07月23日，总交易量 43403 笔。

-- 详细情况见附件二。



-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 在data_from_zabbix库查询

-- 资源方面：

-- 目前，共享扫码付应用环境共有32 个节点。 其中对外业务节点15个。 

-- 共享扫码付数据库环境共有，5个节点。


SELECT '时间',C.zabbixdate FROM cpuandtcpdata C, ip I WHERE C.cpuusemax = ( SELECT MAX(cpuusemax) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 
	AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724' ) AND I.servertypeid = 1 AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724' LIMIT 1;  
/*共享扫码应用节点*/ SELECT 'ip',C.ip FROM cpuandtcpdata C, ip I WHERE C.cpuusemax = ( SELECT MAX(cpuusemax) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 
	AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724' ) AND I.servertypeid = 1 AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724' LIMIT 1;   
/*cpu峰值达到最大值 */ SELECT 'cpu最大值',MAX(cpuusemax) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724'; --  。


SELECT '时间',C.zabbixdate FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724'
 AND C.ip IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ) AND C.tcp_estab = 
( SELECT MAX(tcp_estab) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' 
	AND C.ip IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ) ) LIMIT 1;
/*共享扫码语音播报节点 */
SELECT 'ip',C.ip FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724'
 AND C.ip IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ) AND C.tcp_estab = 
( SELECT MAX(tcp_estab) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' 
	AND C.ip IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ) ) LIMIT 1;
/* TCP-ESTAB峰值达到最大值 */ SELECT 'tcp最大值',MAX(tcp_estab) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' 
AND C.ip IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ); -- 。


SELECT '时间',C.zabbixdate FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724'
 AND C.ip NOT IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ) AND C.tcp_estab = 
( SELECT MAX(tcp_estab) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' 
	AND C.ip NOT IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ) ) LIMIT 1 ;
/*共享扫码应用节点 */SELECT 'ip',I.ip FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724'
 AND C.ip NOT IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ) AND C.tcp_estab = 
( SELECT MAX(tcp_estab) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' 
	AND C.ip NOT IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ) ) LIMIT 1;
/*TCP-ESTAB峰值达到最大值 */ SELECT 'tcp最大值',MAX(tcp_estab) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 1 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' 
AND C.ip NOT IN ( '192.168.1.52', '192.168.1.62', '192.168.1.58' ); -- 。



SELECT '时间',C.zabbixdate FROM cpuandtcpdata C, ip I WHERE C.cpuusemax = ( SELECT MAX(cpuusemax) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 2 
	AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724' ) AND I.servertypeid = 2 AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724' LIMIT 1 ; 
/*共享扫码数据库节点 */ SELECT C.zabbixdate, 'ip',C.ip FROM cpuandtcpdata C, ip I WHERE C.cpuusemax = ( SELECT MAX(cpuusemax) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 2 
	AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724' ) AND I.servertypeid = 2 AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724' LIMIT 1 ; 
/*cpu峰值达到最大值*/ SELECT 'cpu最大值',MAX(cpuusemax) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 2 AND C.ip = I.ip AND C.zabbixdate BETWEEN '20180718' AND '20180724'; --。

 
SELECT '时间',C.zabbixdate FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 2 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' AND C.tcp_estab = 
( SELECT MAX(tcp_estab) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 2 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' ) LIMIT 1;
/*共享扫码数据库节点*/ SELECT 'ip',I.ip FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 2 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' AND C.tcp_estab = 
( SELECT MAX(tcp_estab) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 2 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724' ) LIMIT 1;
/*TCP-ESTAB峰值达到最大值 */ SELECT 'tcp最大值',MAX(tcp_estab) FROM cpuandtcpdata C, ip I WHERE I.servertypeid = 2 AND C.ip = I.ip AND zabbixdate BETWEEN '20180718' AND '20180724'; -- 。

-- 详细情况见附件三。