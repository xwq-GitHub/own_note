# 41nginx基于keepalived的双机热备实施方案

***

## 一、背景说明
> nginx服务作为我司大多数平台的对外接口，极其重要。
> 目前我司的nginx均为单点运行，极不安全。发生故障后应急操作也很不方便。迫切需要增加冗余配置，形成双机乃至多机备份方案。
> 所以特此提出本方案，用于nginx的双机热备。
> keepalived：常用来搭建设备的高可用，防止业务核心设备出现单点故障。keepalived基于VRRP协议来实现高可用，主要用作负载均衡主机和backup主机之间的故障漂移。
> 该方案执行时会停机。预计停机时间15分钟。

## 二、资源梳理

#### 1、硬件资源

全方案所需硬件资源及相关用途如下表：

| 资源编号 | 资源类型  |   相应配置    |    具体用途     | 后续代号 |
| :--: | :---: | :-------: | :---------: | :--: |
|  1   | vm虚拟机 | 8C/8G/40G | 现nginx vm虚机 |  O1  |
|  2   | vm虚拟机 | 8C/8G/40G |  新nginx主节点  |  N1  |
|  3   | vm虚拟机 | 8C/8G/40G |  新nginx备节点  |  N2  |

**上述服务器均需要关闭iptables与selinux**

#### 2、IP资源

全方案所需IP资源及相关用途如下表：

|  编号  |     ip 地址     |    具体用途     |    备注     |
| :--: | :-----------: | :---------: | :-------: |
|  1   | 192.168.1.41  |   现生产ip地址   | 后期会做为浮动IP |
|  2   | 192.168.1.189 | 新nginx主节点ip |   用于O1    |
|  3   | 192.168.1.190 | 新nginx备节点ip |   用于O2    |
|  4   | 192.168.1.191 |   临时浮动ip    |  后期会舍弃不用  |

## 三、操作方案

### （一）、停机前
*此步可以随时操作*

#### 1、 安装keepalived

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

* 主节点(N1)

```shell
cat  keepalived.conf_master > /etc/keepalived/keepalived.conf  #keepalived.conf_master见附件
```

* 备节点(N2)
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
service keepalived reload
```

#### 4、 定义主备状态切换通知脚本notify.sh

```shell
cat  notify.sh  > vim  /etc/keepalived/notify.sh  #notify.sh见附件
```
#### 5、配置Keepalived主备服务器的nginx配置文件同步

> 使用软件：inotify-tools+rsync

> 同步方式：备节点作为服务端。主节点通过rsync服务将配置文件同步到备节点。

* 备节点(N2)

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
* 主节点(N1)

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
### （二）、停机时
*本步操作，预计时间为15min。如果其中某一步发生异常或操作时间超过15min，则建议回退。*
*回退操作详见后文。*

#### 1、同步O1的配置文件到N1、N2

* O1

```shell
tar zcvf /tmp/nginx_conf_`date +%Y%m%d`_O1.tar.gz /usr/local/nginx/conf
scp -P60022 /tmp/nginx_conf_`date +%Y%m%d`_O1.tar.gz root@192.168.1.189:/soft
scp -P60022 /tmp/nginx_conf_`date +%Y%m%d`_O1.tar.gz root@192.168.1.190:/soft -C /
```

* N1、 N2

```shell
rm -fr /usr/local/nginx/conf
tar zxf /soft/nginx_conf_`date +%Y%m%d`_O1.tar.gz -C /   #注意操作时间，如果与上一步不在同一天操作，则相应压缩包名要做更改
```

#### 2、 更改N1、N2浮动IP

```shell
sed -i 's/192.168.1.191/192.168.1.130' /etc/keepalived/keepalived.conf 
```

#### 3、对外暂停 41 IP相关解析

#### 4、转移浮动ip

* O1

  > 通过xencenter工具，卸载该服务器网卡。使其断网。

* N1、 N2

```shell
service nginx restart
service keepalived restart
```

#### 5、观察状态

预期状态如下表

|  主机  |  网卡  |      ip       |
| :--: | :--: | :-----------: |
|  N1  |  lo  |   127.0.0.1   |
|  N1  | eth0 | 192.168.1.189 |
|  N1  | vrrp | 192.168.1.130 |
|  /   |  /   |       /       |
|  N2  |  lo  |   127.0.0.1   |
|  N2  | eth0 | 192.168.1.190 |


通过 `ifconfig` 命令查看网卡状态，如果查看到的状态与预期状态相同，则进行下一步操作。
如果与预期状态不符，则执行回退步骤。

#### 6、恢复 41 IP相关解析

至此，切换完成，服务恢复。

## 四、回退方案

#### 1、对外暂停 41 IP相关解析

#### 2、转移浮动ip


* N1、 N2

> 通过xencenter工具，卸载该服务器网卡。使其断网。

* O1

> 通过xencenter工具，重新加载该服务器网卡。使其连网。
```shell
service network restart
```

#### 3、恢复 41 IP相关解析

## 五、F&Q

>Q：如果切换不成功，回退时会有那些风险？
>
>A：除了操作过程中的停机操作会造成服务暂停外，没有任何风险。



>Q：192.168.1.41是否会同时存在于N1、N2两台服务器上，造成IP冲突？
>
>A：不会。此IP在新的架构中，是一个浮动ip，依存于keepalived。只要keepalived正常工作，此ip就只会在提供服务的主机上，备机上是不会有这个ip的，所以也不会造成ip冲突。



>Q：192.168.1.41是否会同时存在于N1、O1两台服务器上，造成IP冲突？
>
>A：不会。每一次转移ip之前。都会将前一服务器的网卡卸载。此时该服务器是处于断网状态，ip配置虽然在，但是无法生效。



>Q：此方案可否实现自动切换及故障自动修复？
>
>A：本方案可以实现主-->备故障自动切换，但是无法自动修复，需要人工进行修复操作。



> Q：自动切换后，原主节点经过故障处理加入网络后，服务是否会重新被主节点接管？
>
> A：不会。在配置文件中有相关选项。我们使用的是不接替服务的选项。



>Q：双机热备的配置文件如何实现同步？
>
>A：通过 三 / (一) / 5 的配置环节，使用 `inotify-tools+rsync` 工具进行配置文件的实时同步。