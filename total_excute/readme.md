bit.ly/2Hrvegs
github :star7357

#### 각  IP 접속하기.
ssh -i ./skcc.pem centos@[퍼블릭_IP]

|퍼블릭|프라빗|
|---|:---:|
|15.164.140.128 |172.31.39.235|
|15.164.146.139 |172.31.46.208|
|15.164.149.231 |172.31.46.141|
|15.164.152.170 |172.31.42.115|
|15.164.24.103  |172.31.46.235|

#### 참고문서

https://www.cloudera.com/documentation/enterprise/5-15-x/topics/install_cm_mariadb.html#install_cm_mariadb

#### 리눅스 정보 확인하기

리눅스 버전 확인

[root@ip-172-31-39-235 ~]# grep . /etc/*-release
/etc/centos-release:CentOS Linux release 7.6.1810 (Core)
/etc/os-release:NAME="CentOS Linux"
/etc/os-release:VERSION="7 (Core)"
/etc/os-release:ID="centos"
/etc/os-release:ID_LIKE="rhel fedora"
/etc/os-release:VERSION_ID="7"
/etc/os-release:PRETTY_NAME="CentOS Linux 7 (Core)"
/etc/os-release:ANSI_COLOR="0;31"
/etc/os-release:CPE_NAME="cpe:/o:centos:centos:7"
/etc/os-release:HOME_URL="https://www.centos.org/"
/etc/os-release:BUG_REPORT_URL="https://bugs.centos.org/"
/etc/os-release:CENTOS_MANTISBT_PROJECT="CentOS-7"
/etc/os-release:CENTOS_MANTISBT_PROJECT_VERSION="7"
/etc/os-release:REDHAT_SUPPORT_PRODUCT="centos"
/etc/os-release:REDHAT_SUPPORT_PRODUCT_VERSION="7"
/etc/redhat-release:CentOS Linux release 7.6.1810 (Core)
/etc/system-release:CentOS Linux release 7.6.1810 (Core)

리눅스 bit 확인

[root@ip-172-31-39-235 ~]# getconf LONG_BIT
64


- update yum

sudo yum update
sudo yum install -y wget

- add ec2-user to sudoers

sudo visudo
        add -> ec2-user ALL=(ALL) ALL

- change the run level to multi user 

sudo systemctl get-default
sudo systemctl set-default multi-user.target

- disable firewall

sudo systemctl disable firewalld
sudo systemctl status firewalld

- change vm sappiness to 1



1. Check vm.swappiness on all your nodes

https://zetawiki.com/wiki/%EB%A6%AC%EB%88%85%EC%8A%A4_swappiness

vm.swappiness
 스왑 활용도, 스와핑 활용도, 스와피니스
리눅스 커널 속성 중 하나
스왑메모리 활용 수준 조절
스왑 사용의 적극성 수준

값의 범위: 0 ~ 100 (기본값: 60)
vm.swappiness = 0	스왑 사용안함[1]
vm.swappiness = 1	스왑 사용 최소화
vm.swappiness = 60	기본값
vm.swappiness = 100	적극적으로 스왑 사용
```
[root@zetawiki ~]# sysctl vm.swappiness
vm.swappiness = 60

휘발성
[root@zetawiki ~]# sysctl vm.swappiness=40
vm.swappiness = 40

영구  기본값에는 vm.swappiness 설정이 없으므로 새로 추가해주어야 한다.[2] 
[root@zetawiki ~]# vi /etc/sysctl.conf
vm.swappiness = 40
```

2. Show the mount attributes of your volume(s)
3. If you have ext-based volumes, list the reserve space setting
o XFS volumes do not support reserve space

```
[centos@ip-172-31-39-235 ~]$ df -Th
Filesystem     Type      Size  Used Avail Use% Mounted on
/dev/xvda1     xfs       8.0G  896M  7.2G  11% /
devtmpfs       devtmpfs  7.8G     0  7.8G   0% /dev
tmpfs          tmpfs     7.8G     0  7.8G   0% /dev/shm
tmpfs          tmpfs     7.8G   17M  7.8G   1% /run
tmpfs          tmpfs     7.8G     0  7.8G   0% /sys/fs/cgroup
tmpfs          tmpfs     1.6G     0  1.6G   0% /run/user/0
tmpfs          tmpfs     1.6G     0  1.6G   0% /run/user/1000
```

4. Disable transparent hugepage support

https://support.hpe.com/hpsc/doc/public/display?docId=mmr_kc-0111835

```
[centos@ip-172-31-39-235 ~]$ sudo -i
[root@ip-172-31-39-235 ~]# echo never > /sys/kernel/mm/transparent_hugepage/enabled
[root@ip-172-31-39-235 ~]# echo never > /sys/kernel/mm/transparent_hugepage/defrag
[root@ip-172-31-39-235 ~]# cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]
[root@ip-172-31-39-235 ~]#

[centos@ip-172-31-46-208 ~]$ sudo vi /boot/grub/menu.lst
add>>
transparent_hugepage=never
```

5. List your network interface configuration

```
[centos@ip-172-31-39-235 ~]$ ifconfig
ens3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 172.31.39.235  netmask 255.255.240.0  broadcast 172.31.47.255
        inet6 fe80::80e:8bff:fe5b:1b64  prefixlen 64  scopeid 0x20<link>
        ether 0a:0e:8b:5b:1b:64  txqueuelen 1000  (Ethernet)
        RX packets 2152  bytes 219755 (214.6 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1964  bytes 212351 (207.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 6  bytes 416 (416.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 6  bytes 416 (416.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

6. Show that forward and reverse host lookups are correctly resolved
o For /etc/hosts, use getent

https://zetawiki.com/wiki/%EB%A6%AC%EB%88%85%EC%8A%A4_getent

```
[centos@ip-172-31-39-235 ~]$ vi /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.31.39.235   t4h1
172.31.46.208   t4h2
172.31.46.141   t4h3
172.31.42.115   t4h4
172.31.46.235   t4h5

[centos@ip-172-31-39-235 ~]$ getent hosts
127.0.0.1       localhost localhost.localdomain localhost4 localhost4.localdomain4
127.0.0.1       localhost localhost.localdomain localhost6 localhost6.localdomain6
172.31.39.235   t4h1
172.31.46.208   t4h2
172.31.46.141   t4h3
172.31.42.115   t4h4
172.31.46.235   t4h5
 
[root@ip-172-31-39-235 centos]# passwd
Changing password for user root.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
[root@ip-172-31-39-235 centos]# vi /etc/ssh/sshd_config
>>
permissionspassword yes

[root@ip-172-31-39-235 centos]# service sshd restart
Redirecting to /bin/systemctl restart sshd.service

[root@ip-172-31-39-235 centos]# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:WZQH+Vj0A69r067CqN1VsBUgjj05x40KgmzKll0y7Ts root@ip-172-31-39-235.ap-northeast-2.compute.internal
The key's randomart image is:
+---[RSA 2048]----+
|          +=+..  |
|   . o   =o+o* . |
|    * + o B== *  |
| . = = . +.=.= . |
|  = . . S . o .  |
| .     .     +   |
|      E  o  = .  |
|       o..oo o   |
|      ... .....  |
+----[SHA256]-----+

[root@ip-172-31-39-235 ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub t4h2 ~ 4

[root@ip-172-31-39-235 ~]# ssh t4h1
root@t4h1's password:
Last login: Mon May 20 05:16:33 2019 from t4h3
[root@t4h1 ~]# exit
logout
Connection to t4h1 closed.
[root@ip-172-31-39-235 ~]# ssh t4h2
Last login: Mon May 20 05:16:02 2019 from t4h4
[root@t4h2 ~]# exit
logout
Connection to t4h2 closed.
[root@ip-172-31-39-235 ~]# ssh t4h3
root@t4h3's password:
Last login: Mon May 20 05:16:15 2019 from t4h4
[root@t4h3 ~]# exit
logout
Connection to t4h3 closed.
[root@ip-172-31-39-235 ~]# ssh t4h4
root@t4h4's password:
Last login: Mon May 20 05:16:25 2019 from t4h3
[root@t4h4 ~]# exit
logout
Connection to t4h4 closed.
[root@ip-172-31-39-235 ~]# ssh t4h5
Last login: Mon May 20 05:16:58 2019
[root@t4h5 ~]# exit
logout
Connection to t4h5 closed.
```

o For DNS, use nslookup
not installed. can not find packages in centos mirror


7. Show the nscd service is running

```
[centos@ip-172-31-39-235 ~]$ yum install -y nscd
[centos@ip-172-31-39-235 ~]$ sudo service nscd start
Redirecting to /bin/systemctl start nscd.service
```

8. Show the ntpd service is running

```
[centos@ip-172-31-39-235 ~]$ yum install -y ntp
[centos@ip-172-31-39-235 ~]$ sudo service ntpd start
Redirecting to /bin/systemctl start ntpd.service
```

nscd : NIS/NS 를 사용할수 있게 하는 데몬. nscd는 실행중인 프로그램의 그룹을 살피고 패스워드를 변경하거나 다음 질의를 위해 결과를 캐시하는 데몬이다. 
ntpd : NTPv4데몬



Cloudera Manager Install Lab
Path B install using CM 5.15.x
The full rundown is here. You will have to modify your package repo to get the right
release. The default repo download always points to the latest version.

RHEL compatible
Download the cloudera-manager.repo file for your OS version to the /etc/yum.repos.d/ directory on the Cloudera Manager Server host.
See the Repo File column in the Cloudera Manager Version and Download Information table for the URL.

For example:

sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo -P /etc/yum.repos.d/
--2019-05-20 06:04:23--  https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo
Resolving archive.cloudera.com (archive.cloudera.com)... 151.101.108.167
Connecting to archive.cloudera.com (archive.cloudera.com)|151.101.108.167|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 290 [binary/octet-stream]
Saving to: ‘/etc/yum.repos.d/cloudera-manager.repo’

100%[===========================================================================>] 290         --.-K/s   in 0s

2019-05-20 06:04:24 (49.6 MB/s) - ‘/etc/yum.repos.d/cloudera-manager.repo’ saved [290/290]

[root@ip-172-31-39-235 ~]# vi /etc/yum.repos.d/cloudera-manager.repo
[root@ip-172-31-39-235 ~]# cat /etc/yum.repos.d/cloudera-manager.repo
[cloudera-manager]
# Packages for Cloudera Manager, Version 5, on RedHat or CentOS 7 x86_64
name=Cloudera Manager
baseurl=https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.15.0/
#baseurl=https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5/
gpgkey =https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
gpgcheck = 1

Import the repository signing GPG key:
RHEL 7 compatible:
sudo rpm --import https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera


[root@ip-172-31-39-235 ~]# vi /etc/sysconfig//selinux

disable

[root@ip-172-31-39-235 ~]# sestatus
SELinux status:                 disabled

그리고 설치 와 잘되는 지볼려면 web에 붙어보면 되는데 방화벽이  안뚫리는거 같아.

Use the documentation to complete the following objectives:
• Install a supported Oracle JDK on your first node


[root@ip-172-31-39-235 ~]# yum list java*jdk-devel
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: centos.mirror.moack.net
 * extras: centos.mirror.moack.net
 * updates: centos.mirror.moack.net
Available Packages
java-1.6.0-openjdk-devel.x86_64                            1:1.6.0.41-1.13.13.1.el7_3                             base
java-1.7.0-openjdk-devel.x86_64                            1:1.7.0.221-2.6.18.0.el7_6                             updates
java-1.8.0-openjdk-devel.i686                              1:1.8.0.212.b04-0.el7_6                                updates
java-1.8.0-openjdk-devel.x86_64                            1:1.8.0.212.b04-0.el7_6                                updates
java-11-openjdk-devel.i686                                 1:11.0.3.7-0.el7_6                                     updates
java-11-openjdk-devel.x86_64                               1:11.0.3.7-0.el7_6                                     updates
[root@ip-172-31-39-235 ~]# yum install -y java-1.8.0-openjdk-devel.x86_64

• Install a supported JDBC connector on all nodes

[root@ip-172-31-39-235 ~]# wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz
--2019-05-20 06:14:05--  https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz
Resolving dev.mysql.com (dev.mysql.com)... 137.254.60.11
Connecting to dev.mysql.com (dev.mysql.com)|137.254.60.11|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz [following]
--2019-05-20 06:14:06--  https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz
Resolving cdn.mysql.com (cdn.mysql.com)... 23.212.13.170
Connecting to cdn.mysql.com (cdn.mysql.com)|23.212.13.170|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4452049 (4.2M) [application/x-tar-gz]
Saving to: ‘mysql-connector-java-5.1.47.tar.gz’

100%[===========================================================================>] 4,452,049   --.-K/s   in 0.04s

2019-05-20 06:14:06 (94.5 MB/s) - ‘mysql-connector-java-5.1.47.tar.gz’ saved [4452049/4452049]

[root@ip-172-31-39-235 ~]#


• Create the databases and access grants you will need
• Configure Cloudera Manager to connect to the database
• Start your Cloudera Manager server -- debug as necessary
• Do not continue until you can browse your CM instance at port 7180



MySQL/MariaDB Installation Lab
Configure MySQL with a replica server
Choose one of these plans to follow:
• You can use the steps documented here for MariaDB or here for MySQL.

sudo yum install -y mariadb-serve

• The steps below are MySQL-specific.

sudo systemctl stop mariadb


o If you are using RHEL/CentOS 7.x, use MariaDB.
MySQL installation - Plan Two Detail
1. Download and implement the official MySQL repo
o Enable the repo to install MySQL 5.5
o Install the mysql package on all nodes
o Install mysql-server on the server and replica nodes
o Download and copy the JDBC connector to all nodes.
2. You should not need to build a /etc/my.cnf file to start your MySQL server
o You will have to modify it to support replication. Check MySQL
documentation.
3. Start the mysqld service.
4. Use /usr/bin/mysql_secure_installation to:
a. Set password protection for the server
b. Revoke permissions for anonymous users
c. Permit remote privileged login
d. Remove test databases
e. Refresh privileges in memory
f. Refreshes the mysqld service
Cloudera Manager Install Lab
Install a cluster and deploy CDH
Adhere to the following requirements while creating your cluster:
• Do not use Single User Mode. Do not. Don't do it.
• Ignore any steps in the CM wizard that are marked (Optional)
• Install the Data Hub Edition
• Install CDH using parcels
• Deploy only the Core set of CDH services.
• Deploy three ZooKeeper instances.
o CM does not tell you to do this but complains if you don't