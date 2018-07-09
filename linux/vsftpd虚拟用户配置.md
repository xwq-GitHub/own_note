## **vsftpd虚拟用户配置**

1. 安装vsftpd    
		
		yum install vsftpd -y 
2. 设置防火墙

		iptables -A INPUT -p tcp -dport 21 -j ACCEPT
		/etc/init.d/iptables save
		#通过上述方法即可完成对vsftpd服务的匿名用户访问设置。

3. 设置虚拟用户   

		vim /etc/vsftpd/loginusers
			zhang1
			1
			zhang2
			2
			zhang3
			3						#虚拟账号及密码
			db_load -T -t hash -f /etc/vsftpd/loginusers /etc/vsftpd/loginusers.db          ##加密帐号文件
			vim /etc/pam.d/ckvsftpd          #创建pam文件
				account required        pam_userdb.so   db=/etc/vsftpd/loginusers    #注意DB文件不能加.db后缀
				auth    required        pam_userdb.so   db=/etc/vsftpd/loginusers
			vim /etc/vsftpd/vsftpd.conf
				pam_service_name=ckvsftpd
				guest_enable=YES  
				guest_username=ftp  
			mkdir /ftphome
			chgrp ftp /ftphome
			chmod g+s /ftphome
			mkdir /ftphome/zhang{1..3}
			vim /etc/vsftpd/vsftpd.conf
				local_root=/ftphome/$USER
				user_sub_token=$USER 
			#此时已经完成了对于ftp匿名用户的配置，并且可以通过匿名用户访问ftp。但是匿名用户并不能在自己的家目录上传文件。并且也看不到自己家目录中的文件。   
			#经过分别关闭selinux以及iptables。发现关闭防火墙后对这种现象并没有改变。但是当selinux的状态从Enforcing改为Permissive后，用户可以正常访问自己的家目录了。所以猜想此处是因为虚拟用户家目录的安全上下文的问题。

4. 安全上下文   

		chcon -t public_content_t /ftphome/ -R



