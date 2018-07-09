* 手动挂载方式
	
    
    yum install nfs-utils
	showmount -e ip
	mount ip:/sharedir /mountpoint


* 自动挂载方式

	
	yum install autofs
	systemctl start autofs
	cd /net/ip/
	vim /etc/syscofig/autofs
		TIMEOUT=5

* 自定义挂载方式
	
    
    vim /etc/auto.master
	#最终挂载点的上层目录	自策略文件
	    /nfs			/etc/auto.nfs
	    #vim 自策略文件(vim /etc/auto.nfs)	
	    #最终挂载点	网络挂载资源
	    nfs1		172.25.254.250:/nfsshare/nfs1
	    *		172.25.254.250:/nfsshare/&
	
	    systemctl restart autofs

	cd /nfs/nfs1

    df
    Filesystem                    1K-blocks     Used Available Use% Mounted on
    /dev/vda1                      10473900  3262308   7211592  32% /
    devtmpfs                         927072        0    927072   0% /dev
    tmpfs                            942660        0    942660   0% /dev/shm
    tmpfs                            942660    16968    925692   2% /run
    tmpfs                            942660        0    942660   0% /sys/fs/cgroup
    /dev/vdb1                       1038336   749744    288592  73% /pub
    172.25.254.250:/nfsshare/nfs1 100221952 57231360  42990592  58% /nfs/nfs1