* cifs


    yum install samba-client
    smbclient -L //ip
    smbclient //ip/sharename
    #或
	mount //ip/sharename /mountpoint -o username=guest
	vim /etc/fstab
	//ip/sharename /mountpoint cifs	defaults,username=guest 0 0
	mount -a

	