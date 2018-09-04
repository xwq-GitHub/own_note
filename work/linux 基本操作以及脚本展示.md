# linux 基本以及脚本展示
***


## 一、linux基础

### 1、shell

命令解析器，俗称壳，用来与核（内核，kernel）进行区分。
shell的作用是，用来与内核进行交流，以保护内核。
我们大多数敲的命令，进行的操作都是在shell中进行。

* shell种类

  >   Linux 的 Shell 种类众多，常见的有：

  >  Bourne Shell（/usr/bin/sh或/bin/sh）
  >  Bourne Again Shell（/bin/bash）
  >  C Shell（/usr/bin/csh）
  >  K Shell（/usr/bin/ksh）
  >  Shell for Root（/sbin/sh）

一般交流沟通中所说的shell，指的是Bash，即Bourne Shell。

### 2、centos默认登录提示符

*我司目前大规模使用的系统为 centos6.7，个别的有一些 rhel 5.11 32位系统。*
*下述所有内容能够均基于 centos6.7进行介绍。可能不适用于其他系统，请知晓。*
*同理，所有的内容均基于 bash，而非其他 shell。*

当我们登录一台主机后，会在命令行中发现如下信息。
`[kiosk@foundation45 Desktop]$`
这个信息即为登录提示符，用来为用户提供当前信息。具体内容如下：
```shell
kiosk ##开启shell的用户
@ ##分隔符
foundation45 ##主机的短名，表示shell开启在那台主机中
Desktop ##表示在系统的什么位置
$ ##身份提示符中的普通用户，而‘#’表示超级用户
```

命令提示符可以修改，但是对于生产主机不允许做修改。本处不进行介绍。


### 3、linux基本目录结构

**在linux中，文件夹叫做目录，目录本身也是文件。linux的哲学为一切皆文件。**

```shell
linux系统结构是倒树型，具体目录功能如下：

/bin ##binary，二进制可执行文件，即系统命令
/sbin ##system binary，系统管理命令存放位置，仅root用户可执行
/boot ##启动分区，负责系统启动
/dev ##设备管理文件
/etc ##大多数系统管理文件，即系统的配置
/home ##普通用户的家目录
/lib ##library，32位系统库文件存放位置
/lib64 ##library64，64位系统库文件存放位置
/media、/mnt，/run ##系统临时设备挂载点
/opt ##第三方软件安装位置
/proc ##系统信息
/root ##超级用户的家目录
/srv，/var ##系统数据
/sys ##系统管理，主要是关于内核的
/tmp ##系统临时文件存放位置
/usr ##系统用户相关信息数据及用户自定义软件存放位置
```

### 4、系统路径
绝对路径(absolute paths)：文件在系统的真实位置，文件名字以‘/’开头。
相对路径(relative paths)：文件相对与当前所在位置名字的一个简写，不会以‘/’开头，并名字会自动添加‘pwd’的值。



## 二、linux基本命令及操作

### 1、linux基本命令


```shell
ls  #通过ls命令不仅可以查看linux文件夹包含的文件，还可以查看文件权限(包括目录、文件夹、文件权限)、查看目录信息等等

cd  #切换当前目录至dirName

pwd  #查看当前工作目录路径

mkdir  #创建文件夹

rm  #删除一个目录中的一个或多个文件或目录

mv  #移动文件或修改文件名

cp  #将源文件复制至目标文件，或将多个源文件复制至目标目录。

cat  #一次显示整个文件

more  #功能类似于cat, more会以一页一页的显示方便使用者逐页阅读，而最基本的指令就是按空白键（space）就往下一页显示，按 b 键就会往回（back）一页显示

less  #less 与 more 类似，但使用 less 可以随意浏览文件，而 more 仅能向前移动，却不能向后移动，而且 less 在查看之前不会加载整个文件。

head  #用来显示档案的开头至标准输出中

tail  #用于显示指定文件末尾内容，不指定文件时，作为输入信息进行处理。常用查看日志文件

du  #是对文件和目录磁盘使用的空间的查看

grep  #全局正则表达式搜索

wc  #统计指定的文件中字节数、字数、行数，并将统计结果输出 

find  #用于在文件树中查找文件，并作出相应的处理

tar  #用来压缩和解压文件

ln  #为文件在另外一个位置建立一个同步的链接

man  #是Linux下的帮助指令，通过man指令可以查看Linux中的指令帮助、配置文件帮助和编程帮助等信息
```

### 2、linux基本操作

- ##### 系统时间调整

```shell
ntpdate 192.168.1.128  #与ntp服务器对时
date -s '20180903'  #更改服务器时间
clock -w  #将时间记录至cmos，以修改计时电路的时间
```

* ##### 创建用户及权限管理
```shell
useradd test  #添加test用户
usetdel test  #删除test用户
passwd test #修改test用用户密码
chown test.test ${filename} #修改文件属主
su - ${user}  #用户切换，-代表环境变量。建议非特殊情况，一定要在切换用户时使用 - 。
id ${user}  #显示用户信息
```

* ##### 文件权限管理
```shell
chmod +x ${filename}  为文件增加执行权限
chmod -w ${filename}  删除文件写权限
chmod 755 ${filename} 将文件权限设置为755
chmod g-x ${filename} 删除文件属组的执行权限
r=4 w=2 x=1  #权限说明
```

* ##### 安装卸载软件
```shell
rpm -ivh ${rpmname}.rpm 安装rpm包
rpm -e ${rpmname}  卸载包名可以包含版本号等信息，但是不可以有后缀.rpm
yum install ${rpmname}.rpm 安装rpm包
yum remove ${rpmname}.rpm 卸载rpm包
```

* ##### 磁盘分区
```shell
fdisk /dev/sdb #对第二块硬盘进行操作
Command (m for help): p #列出现有分区
Command (m for help): d #删除分区
Command (m for help): n #新建分区
Command action
   e   extended
   p   primary partition (1-4)   #选择分区类型。e为扩展分区，p为主分区
Partition number (1-4): 1  #分区号
First cylinder (1-391, default 1): #分区起始位置，默认为1
last cylinder or +size or +sizeM or +sizeK (1-391, default 391):   #分区结束位置，默认为最后一个扇区，单位为扇区
Command (m for help): w #报错修改
mkfs.ext4 /dev/sdb1 #格式化分区
```

* ##### 硬盘挂载
```shell
mount /dev/sdb1 /mnt  #将sdb1挂载到/mnt目录
df #查看硬盘及相关挂载信息
umount /mnt #解除/mnt目录的挂载
```

* ##### vim基本操作

为什么使用vim？
    所有的 Unix Like 系统都会内建 vi 文书编辑器，其他的文书编辑器则不一定会存在。
什么是 vim？
    Vim是从 vi 发展出来的一个文本编辑器。代码补完、编译及错误跳转等方便编程的功能特别丰富，在程序员中被广泛使用。
vi/vim 的使用？
    基本上 vi/vim 共分为三种模式，分别是命令模式（Command mode），输入模式（Insert mode）和底线命令模式（Last line mode）。

  >命令模式：
  >用户刚刚启动 vi/vim，便进入了命令模式。
  >
  >此状态下敲击键盘动作会被Vim识别为命令，而非输入字符。比如我们此时按下i，并不会输入一个字符，i被当作了一个命令。
  >
  >以下是常用的几个命令：
  >
  >i 切换到输入模式，以输入字符。
  >x 删除当前光标所在处的字符。
  >: 切换到底线命令模式，以在最底一行输入命令。
  >若想要编辑文本：启动Vim，进入了命令模式，按下i，切换到输入模式。
  >
  >命令模式只有一些最基本的命令，因此仍要依靠底线命令模式输入更多命令。

  >输入模式：
  >在命令模式下按下i就进入了输入模式。
  >
  >在输入模式中，可以使用以下按键：
  >
  >字符按键以及Shift组合，输入字符
  >ENTER，回车键，换行
  >BACK SPACE，退格键，删除光标前一个字符
  >DEL，删除键，删除光标后一个字符
  >方向键，在文本中移动光标
  >HOME/END，移动光标到行首/行尾
  >Page Up/Page Down，上/下翻页
  >Insert，切换光标为输入/替换模式，光标将变成竖线/下划线
  >ESC，退出输入模式，切换到命令模式

  >底线命令模式：
  >在命令模式下按下:（英文冒号）就进入了底线命令模式。
  >
  >底线命令模式可以输入单个或多个字符的命令，可用的命令非常多。
  >
  >在底线命令模式中，基本的命令有（已经省略了冒号）：
  >
  >q 退出程序
  >w 保存文件
  >按ESC键可随时退出底线命令模式。

* ##### crontab（任务计划）配置与查看
```shell
crontal -l #查看当前用户的任务计划
crontab -e #修改当前用户的任务计划

#任务计划格式
minute   hour   day   month   week   command     顺序：分 时 日 月 周

#任务计划示例
51 * * * * root run-parts /etc/cron.hourly
24 7 * * * root run-parts /etc/cron.daily
22 4 * * 0 root run-parts /etc/cron.weekly
42 4 1 * * root run-parts /etc/cron.monthly
```

* ##### 网络配置
```shell
vim /etc/sysconfig/network-scripts/ifcfg-eth0

	DEVICE=eth0 #设备名
	ONBOOT=yes #是否启动
	BOOTPROTO=static #网络类型
	IPADDR=172.17.16.15 #ip地址
	NETMASK=255.255.240.0 #子网掩码
	GATEWAY=172.17.16.254 #网关
	DNS1=114.114.114.114 #DNS
```

* ##### 进程管理
```shell
ps -ef |grep vim #查看包含vim字符的相关进程信息
用户      pid   ppid  处理器使用率百分比 开始时间 终端名称 进程所用的CPU时间总数（自从启动）  命令
root     11184 10767  0                17:58    pts/0    00:00:00                      vim /etc/sysconfig/network-scripts/ifcfg-eth0
root     11236 10767  0                18:00    pts/0    00:00:00                      grep vim

top 可以实时动态地查看系统的整体运行情况
http://note.youdao.com/noteshare?id=dbe5dd2f10e5fea3dfd3843ebeebf9ad&sub=94C1203389584ECF8B9CEAA91E81A462

free  #显示系统内存使用情况 

kill -9 ${PID} #强制终止进程
```

### 3、运维工具介绍


* ##### [htop](https://github.com/fushisanlang/own_note/blob/master/linux/htop%E5%B7%A5%E5%85%B7.md)
* ##### [dstat](https://github.com/fushisanlang/own_note/blob/master/linux/dstat%E5%B7%A5%E5%85%B7.md)
* ##### [glances](https://github.com/fushisanlang/own_note/blob/master/linux/glances%E5%B7%A5%E5%85%B7.md)


***

## 三、shell脚本基础

### 1、shell脚本基础

shell脚本一般通过.sh后缀标识。

* shell脚本执行方式
       一般的脚本有两种执行方式。
```shell
chmod +x test.sh
./test.sh
#这种方式，第一行需要指明运行所需的解释器。
```
或
```shell
/bin/sh test.sh
```

### 2、注释

  shell中的注释符号为 `#` 。

### 3、变量

  * 定义变量:变量名不加 `$`，如：`your_name="hahaha"`

 * 变量命名规范：

>命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
>中间不能有空格，可以使用下划线（_）。
>不能使用标点符号。
>不能使用bash里的关键字（可用help命令查看保留关键字）。

  * 使用变量:使用一个定义过的变量，只要在变量名前面加 ` $ ` 即可,如： `echo $your_name`

  * 删除变量：使用 `unset` 命令可以删除变量。如:`unset your_name`

### 4、传递参数

可以在执行 Shell 脚本时，向脚本传递参数，脚本内获取参数的格式为：$n。n 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推……

另外，还有一些特殊参数如下：

```shell
$#	传递到脚本的参数个数
$*	以一个单字符串显示所有向脚本传递的参数。如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。
$$	脚本运行的当前进程ID号
$!	后台运行的最后一个进程的ID号
$@	与$*相同，但是使用时加引号，并在引号中返回每个参数。如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。
$-	显示Shell使用的当前选项，与set命令功能相同。
$?	显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。

$* 与 $@ 区别：
相同点：都是引用所有参数。
不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，，则 " * " 等价于 "1 2 3"（传递了一个参数），而 "@" 等价于 "1" "2" "3"（传递了三个参数）。
```

在执行脚本时，可以通过参数的方式向脚本内部传递变量，也可以在执行脚本的工程中，通过标准输入向脚本传递变量。

```shell
read yourname    #通过标准输入读取输入并为yourname变量赋值。  
read yourname myname   #从标准输入读取输入到第一个空格或者回车，将输入的第一个单词放到变量yourname中，并将该行其他的输入放在变量myname中。
```

### 5、输入、输出与重定向

* ##### 标准输入与标准输出

  一个命令通常从一个叫标准输入的地方读取输入，默认情况下，这恰好是你的终端。同样，一个命令通常将其输出写入到标准输出，默认情况下，这也是你的终端。

* ##### 输出重定向

  一般的，执行脚本的过程与结果，会输出到标准输出（你的终端）上，有时为了记录日志，会将输出定向到文件中。一般这种操作会通过重定向符 `>`  实现。

```shell
echo "hello world" > hello_world.txt    #将hello world字符输入到hello_world.txt文件中。会修改之前的文件内容。
echo "hello world" >> hello_world.txt   #将hello world字符追加输入到hello_world.txt文件中。不会修改之前的文件内容。
```

* ##### 输入重定向
```shell
command1 < file1   #将file1的内容输入到command1中。

$ wc -l users
       2 users

$  wc -l < users
       2 
#注意：上面两个例子的结果不同：第一个例子，会输出文件名；第二个不会，因为它仅仅知道从标准输入读取内容。   
```

### 6、常用判断与循环

* ##### if  与 if else 

在sh/bash中，如果else分支没有语句执行，就不要写这个else。

```shell
if condition
then
    command
fi

if condition
then
    command1
else
    command2
fi
```

* ##### case

```shell
case 值 in
模式1)
    command1
    ;;
模式2）
    command2
    ;;
esac
```

* ##### for循环

```shell
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

* ##### while循环

```shell
while condition
do
    command
done
```

* ##### break命令

break命令允许跳出所有循环（终止执行后面的所有循环）。

### 7、定义函数

```shell
[ function ] funname [()]
{
    action;
    [return int;]
}
```

***


## 四、shell脚本展示

### 1、url压力测试脚本

```shell
#!/bin/bash

#for Probe url and count failure rate.
#by ZhangYin.
#Thanks for the help of Echo7.

function shell_help () {
echo -e "\e[1;33mUsage: curl13 [OPTION]\e[0m"
echo -e "\e[1;33mProbe url and count failure rate.\e[0m"
echo -e ""
echo -e "\e[1;34m    -h, --help         Shell help\e[0m"
echo -e "\e[1;34m    -i, --interval     Probe interval\e[0m"
echo -e "\e[1;34m    -t, --totaltime    Total number of probes\e[0m"
echo -e "\e[1;34m    -u, --url          The url used to probe\e[0m"
echo -e "\e[1;34m    -T, --timeout      Timeout for each probe\e[0m"
echo -e "\e[1;34m    -l, --logfile      Logfile\e[0m"
}

function rotate() {
local INTERVAL=0.25
local RCOUNT="0"
echo -e "\e[1;31mexploring\e[0m"
while :
do
    ((RCOUNT = RCOUNT + 1))
    case $RCOUNT in
        1) echo -e '-\b\c'
            sleep $INTERVAL
            ;;
        2) echo -e '\\\b\c'
            sleep $INTERVAL
            ;;
        3) echo -e '|\b\c'
            sleep $INTERVAL
            ;;
        4) echo -e '/\b\c'
            sleep $INTERVAL
            ;;
        *) RCOUNT=0
            ;;
    esac
done
}

function Probe_interval () {
if [[  -n ${1} ]] ; then
    sleep ${1}
fi
}

function TANCE () {
> ${logfile}	
rotate &
trap "kill -9 $BG_PID" INT
ROTATE_PID=$!
for((i=1;i<=${1};i++));   do    curl -s -o /dev/null  --w "%{http_code}\n"  ${2} --connect-timeout ${3} -m 1 >> ${4} ; Probe_interval ${5}; done
echo -e '\b'
}

function REPORT () {
local ALL=`cat ${1}  | wc -l`
local SUE=`cat ${1}  | grep 200 |wc -l`
local FAI=`cat ${1}  | grep -v 200 |wc -l` 
rm -fr ${1}
echo -e "\e[1;33m The following is the test data: \e[0m"
echo -e " We have already sent a total of \e[1;34m ${ALL} \e[0m requests."
echo -e " There is \e[1;31m `echo "scale=2;$FAI/$ALL*100" |bc |awk -F '.' '{print $1}'` percent \e[0m failure rate. A total of  \e[1;31m `echo ${FAI}`  \e[0m requests failed"
echo -e " Thanks for using."
kill -9 $ROTATE_PID
echo -e "\e[1;32mfinished\e[0m"
}

fulltime=1
url='192.168.2.243/jfpt_qd/logon!toAdminlogon.action'
timeout=1
logfile=result.log

#echo $1
while [ -n "$1" ]
do
    case "$1" in
        -t|--fulltime) fulltime=$2; shift 2;;
        -u|--url) url=$2; shift 2;;
        -T|--timeout) timeout=$2; shift 2;;
        -l|--logfile) logfile=$2; shift 2;;
        -i|--interval) interval=$2; shift 2;;
        -h|--help) shell_help; exit 1;;
        --) break ;;
        *) shell_help; break ;;
    esac
done
TANCE ${fulltime} ${url} ${timeout} ${logfile} ${interval}
REPORT ${logfile}
```


### 2、数据库备份传输脚本

```shell
#!/bin/bash
#for ronglian db_bak transfer from IDC to SANYI_office.
#base on openssh & scp
#by ronglian_devops
#with_out jspt
#version 0822.1123

DATE=`date +%Y%m%d`
DELDATE=`date -d -21day +%Y%m%d`
BAKDIR=/data/hisdata/${DATE}/
DELBAKDIR=/data/hisdata/${DELDATE}/
LOG=${BAKDIR}${DATE}
BAKFROM=/data/dbbackup/
FILEDIS=_01.gz
MOUNTDIR=/tmp/nfs/
NAMEDIR=/data/dbbackup/shell/
NAMEFILE=name.txt
NAMEFILE2=${DATE}_name.txt
VMLIST="192.168.68.16 192.168.69.3 192.168.1.40 192.168.1.110 192.168.1.113 192.168.1.102 192.168.1.160 192.168.68.3 192.168.68.34 "

#######create a log file
function createlog () {
    mkdir -p ${BAKDIR}
    echo '<html><head><style>p.no{color:red}p.yes{color:green}</style></head><body> ' > ${LOG}.html
    echo "<H1 align=center> ${DATE} </H1>" >> ${LOG}.html
    echo "<H3 align=center> <a href="http://tool.chinaz.com/Tools/unixtime.aspx">switch date format</a>  </H3>" >> ${LOG}.html
}
#######finish a log file
function finishlog () {
    echo '</body></html>' >> ${LOG}.html
}
#######definition a print log function
function printlog () {
    if [ $? -eq 0 ]; then
        echo " <p class=yes>  `date +%s` ${1} done  </p> <br> " >> ${LOG}.html
        echo -e " `date +%s` \e[1;32m  ${1} done  \e[0m " >> ${LOG}.txt
    else
        echo " <p class=no>  `date +%s` ${1} error  </p> <br> " >> ${LOG}.html
        echo -e " `date +%s` \e[1;31m  $1 error \e[0m " >> ${LOG}.txt
    fi
}
#######use for get db names
function getname () {
    scp -P60022 dbbackup@${1}:${NAMEDIR}${NAMEFILE} ${NAMEDIR}${NAMEFILE}_${1}
    printlog "get ${1} namefile"
    cat ${NAMEDIR}${NAMEFILE}_${1}|sed "s/^/${1}:/g" >> ${NAMEDIR}${NAMEFILE2}
}
#######use for merge the db names 
function O_getname () {
    > ${NAMEDIR}${NAMEFILE2}
    for VMIP in ${VMLIST}
    do
       getname ${VMIP}
    done
    printlog "merge namefile"
}
#######use for get db bak
function getdbbak () {
    mkdir -p ${BAKDIR}
    scp -P60022 dbbackup@${1}:${BAKFROM}${2}/${2}${DATE}${FILEDIS} ${BAKDIR}
    printlog "get ${2} dbbak from ${1}"
} 
#######use for  get all db bak
function O_getdbbak () {
    cat ${NAMEDIR}${NAMEFILE2}|
    while read IP_DB
    do
        KEY_IP=`echo ${IP_DB} | awk -F ':' '{print $1}' `
        VALUE_DB=`echo ${IP_DB} | awk -F ':' '{print $2}'`
        getdbbak ${KEY_IP} ${VALUE_DB}
    done
    printlog "get all bakfiles"
}
#######use for push db bak
function pushdbbak () {
    scp -l 40000 ${1}  root@192.168.3.138:/volume1/dbbackup/${DATE}
    printlog "push ${1} dbbak"
}
#######use for push all db bak
function O_pushdbbak () {
    ssh -f root@192.168.3.138 "mkdir -p /volume1/dbbackup/${DATE}"
    printlog "create  ${DATE} dir on NAS"
    ls -l  ${BAKDIR}/* | awk -F ' ' '{print $NF}'|
    while read BAKNAME
    do
        pushdbbak ${BAKNAME}
    done
    printlog "push all bakfiles"
}
#######use for del 21days ago bak
function deloldfile () {
    rm -fr ${DELBAKDIR}
    printlog "del ${DELBAKDIR}"
}
#######use for push log
function pushlog () {
    scp ${LOG}.html root@192.168.1.139:/usr/local/nginx/html/IDC2office.html 
}
#######actual operation
createlog
O_getname
O_getdbbak
O_pushdbbak
deloldfile
printlog "the last step"
finishlog
pushlog
```