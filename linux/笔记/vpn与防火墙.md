vpn与防火墙

vpn

通过vpn可以建立隧道。通过隧道从外网访问内网。

有两种模式。

硬件vpn与软件vpn。

硬件模式通过两个硬件vpn链接，建立静态隧道。

软件vpn通过分发vpn证书，通过软件建立一条通信隧道。

vpn网址为218.30.21.16:8080

最主要的功能目录是虚拟专网的静态隧道和VRC管理。

协商成功就是链接成功，停止是断开，正在协商可能是连接中或者有问题未连接上。

软件vpn安装

需要先安装vrc客户端，并且拥有证书。

安装好客户端后，打开客户端软件吗，新建连接，添加证书。证书为口令加证书模式，本地tar文件，然后选择自己的证书并导入。

导入证书之后，输入自己的密码，然后在高级选项中勾选自动认证（保存设置）和保存证书设置，记录客户端日志（基本日志），保存设置。需要注意，每改一个不同项的设置后，都要保存设置。

全部设置完毕之后，选择连接。客户端开始创建隧道。当图标从红色变成绿色，表示隧道建立成功，连接可用。

防火墙

通过防火墙链接，并且进行地址映射。

在实际环境中，整个集群只有一个或几个公网IP。但是其实内部的服务器有许多台，为了使不同的业务能找到不同的服务器，就需防火墙进行地址映射，将不同的业务从单一的外网IP映射到不同的内网IP。




