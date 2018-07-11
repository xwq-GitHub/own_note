# 41nginx基于keepalived的双机热备实施方案

***

## 一、背景说明
nginx服务作为我司大多数平台的对外接口，极其重要。

目前我司的nginx均为单点运行，极不安全。发生故障后应急操作也很不方便。迫切需要增加冗余配置，形成双机乃至多机备份方案。

所以特此提出本方案，用于nginx的双机热备。

keepalived：常用来搭建设备的高可用，防止业务核心设备出现单点故障。keepalived基于VRRP协议来实现高可用，主要用作负载均衡主机和backup主机之间的故障漂移。

该方案执行时会停机。预计停机时间15分钟。



## 二、资源梳理

#### 1、硬件资源

全方案所需硬件资源及相关用途如下表：

| 资源编号 | 资源类型  |   相应配置    |    具体用途     | 后续代号 |
| :--: | :---: | :-------: | :---------: | :--: |
|  1   | vm虚拟机 | 8C/8G/40G | 现nginx vm虚机 |  O1  |
|  2   | vm虚拟机 | 8C/8G/40G |  新nginx主节点  |  N1  |
|  3   | vm虚拟机 | 8C/8G/40G |  新nginx备节点  |  N2  |

#### 2、IP资源

全方案所需IP资源及相关用途如下表：

|  编号  |     ip 地址     |    具体用途     |    备注     |
| :--: | :-----------: | :---------: | :-------: |
|  1   | 192.168.1.41  |   现生产ip地址   | 后期会做为浮动IP |
|  2   | 192.168.1.189 | 新nginx主节点ip |   用于O1    |
|  3   | 192.168.1.190 | 新nginx备节点ip |   用于O2    |

## 三、操作方案

### （一）、操作前步骤

#### 1. 安装keepalived

```shell
yum install -y openssl-devel
mkdir -p /soft
cd /soft/
wget http://www.keepalived.org/software/keepalived-1.3.5.tar.gz
tar -zvxf keepalived-1.3.5.tar.gz
cd keepalived-1.3.5
./configure --prefix=/usr/local/keepalived
make && make install
cp /soft/keepalived-1.3.5/keepalived/etc/init.d/keepalived /etc/rc.d/init.d/
cp  /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/
mkdir /etc/keepalived/
cp /usr/local/keepalived/etc/keepalived/keepalived.conf  /etc/keepalived/
cp /usr/local/keepalived/sbin/keepalived  /usr/sbin/
chmod +x /etc/rc.d/init.d/keepalived
service keepalived start
```

#### 2、 配置keepalived

* 主节点(O1)

```shell
cat  keepalived.conf_master > /etc/keepalived/keepalived.conf  #keepalived.conf_master见附件
```

* 备节点(O2)
```shell
cat  keepalived.conf_slave > /etc/keepalived/keepalived.conf   #keepalived.conf_slave见附件
```

#### 3、 配置日志

```shell
vim /etc/sysconfig/keepalived   #修改
	KEEPALIVED_OPTIONS="-f /etc/keepalived/keepalived.conf  -D -S 0"  

vim  /etc/rsyslog.conf   #增加
	local0.*          /var/log/keepalived/keepalived.log 
	
mkdir /var/log/keepalived 
touch /var/log/keepalived/keepalived.log
service rsyslog  reload
```

#### 4、 主备定义主备状态切换通知脚本notify.sh

```shell
cat  notify.sh  > vim  /etc/keepalived/notify.sh  #notify.sh见附件
```
#### 5、配置Keepalived主备服务器的nginx配置文件同步

使用软件：inotify-tools+rsync

同步方式：备节点作为服务端。主节点通过rsync服务将配置文件同步到备节点。

* 备节点(O2)

```shell
yum install rsync xinetd 
vi /etc/xinetd.d/rsync  
	disable = no #修改,默认为yes
/etc/init.d/xinetd start
cat rsyncd.conf > /etc/rsyncd.conf   #rsyncd.conf见附件
echo "bak:bak"  > /etc/rsyncd.pass
chmod  600  /etc/rsyncd.conf  #设置文件所有者读取、写入权限
chmod  600  /etc/rsyncd.pass
service xinetd restart  #重新启动
```
* 主节点(O1)

```shell
yum install rsync  
echo "bak" >  /etc/rsyncd.pass
chmod  600  /etc/rsyncd.pass  
yum install inotify-tools -y
cat notify-rsync > /usr/bin/notify-rsync
```
* 优化inotify
  在/proc/sys/fs/inotify目录下有三个文件，对inotify机制有一定的限制
  * max_user_watches #设置inotifywait或inotifywatch命令可以监视的文件数量(单进程)
  * max_user_instances #设置每个用户可以运行的inotifywait或inotifywatch命令的进程数
  * max_queued_events #设置inotify实例事件(event)队列可容纳的事件数量


```shell
echo 50000000 > /proc/sys/fs/inotify/max_user_watches
echo 50000000 > /proc/sys/fs/inotify/max_queued_events
vim  /etc/rc.d/rc.local #将nginx配置文件实时同步脚本和inotify优化参数加入开机自启
	sh /usr/bin/notify-rsync &
	echo 50000000 > /proc/sys/fs/inotify/max_user_watches
	echo 50000000 > /proc/sys/fs/inotify/max_queued_events
```

* 添加定时任务

```shell
crontab  -e  #因为inotify只在启动时会监控目录，他没有启动期间的文件发生更改，他是不知道的，所以这里每2个小时做1次全量同步，防止各种意外遗漏，保证目录一致。
	* */2 * * *  /usr/bin/rsync -avz --password-file=/etc/rsyncd.pass /usr/local/nginx/conf/  bak@192.168.1.219::180-nginx
```
### （二）、操作步骤

#### 1、 O1、O2网络配置

通过xencenter控制台，将O1、O2两台vm的网卡卸载