SSH를 사용하여 인스턴스에 연결하려면

터미널 창에서 ssh 명령을 사용하여 인스턴스에 연결합니다. 프라이빗 키(.pem) 파일과 user_name@public_dns_name을 지정합니다. 예를 들어 Amazon Linux 2 또는 Amazon Linux AMI를 사용한 경우 사용자 이름은 ec2-user입니다.

ssh -i /path/my-key-pair.pem ec2-user@ec2-198-51-100-1.compute-1.amazonaws.com
다음과 같은 응답이 표시됩니다:

The authenticity of host 'ec2-198-51-100-1.compute-1.amazonaws.com (10.254.142.33)'
can't be established.
RSA key fingerprint is 1f:51:ae:28:bf:89:e9:d8:1f:25:5d:37:2d:7d:b8:ca:9f:f5:f1:6f.
Are you sure you want to continue connecting (yes/no)?
(IPv6 전용) 또는 IPv6 주소를 이용해 인스턴스에 연결할 수도 있습니다. 프라이빗 키(.pem) 파일 경로 및 적절한 사용자 이름과 IPv6 주소를 사용하여 ssh 명령을 지정합니다. 예를 들어 Amazon Linux 2 또는 Amazon Linux AMI를 사용한 경우 사용자 이름은 ec2-user입니다.

ssh -i /path/my-key-pair.pem ec2-user@2001:db8:1234:1a00:9691:9503:25ad:1761
(선택 사항) 보안 알림의 지문이 앞의 (선택 사항) 인스턴스 지문 가져오기에서 얻은 지문과 일치하는지 확인합니다. 이들 지문이 일치하지 않으면 누군가가 "메시지 가로채기(man-in-the-middle)" 공격을 시도하고 있는 것일 수 있습니다. 이들 지문이 일치하면 다음 단계를 계속 진행합니다.

yes를 입력합니다.

다음과 같은 응답이 표시됩니다:

Warning: Permanently added 'ec2-198-51-100-1.compute-1.amazonaws.com' (RSA) 
to the list of known hosts.


퍼블릭                      프라빗
ssh -i ./skcc.pem centos@15.164.140.128        172.31.39.235
ssh -i ./skcc.pem centos@15.164.146.139        172.31.46.208
ssh -i ./skcc.pem centos@15.164.149.231        172.31.46.141
ssh -i ./skcc.pem centos@15.164.152.170        172.31.42.115
ssh -i ./skcc.pem centos@15.164.24.103         172.31.46.235

https://www.cloudera.com/documentation/enterprise/5-5-x/topics/cdh_admin_performance.html




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

[root@zetawiki ~]# sysctl vm.swappiness
vm.swappiness = 60

휘발성
[root@zetawiki ~]# sysctl vm.swappiness=40
vm.swappiness = 40

영구  기본값에는 vm.swappiness 설정이 없으므로 새로 추가해주어야 한다.[2] 
[root@zetawiki ~]# vi /etc/sysctl.conf
vm.swappiness = 40


2. Show the mount attributes of your volume(s)
3. If you have ext-based volumes, list the reserve space setting
o XFS volumes do not support reserve space

[centos@ip-172-31-39-235 ~]$ df -Th
Filesystem     Type      Size  Used Avail Use% Mounted on
/dev/xvda1     xfs       8.0G  896M  7.2G  11% /
devtmpfs       devtmpfs  7.8G     0  7.8G   0% /dev
tmpfs          tmpfs     7.8G     0  7.8G   0% /dev/shm
tmpfs          tmpfs     7.8G   17M  7.8G   1% /run
tmpfs          tmpfs     7.8G     0  7.8G   0% /sys/fs/cgroup
tmpfs          tmpfs     1.6G     0  1.6G   0% /run/user/0
tmpfs          tmpfs     1.6G     0  1.6G   0% /run/user/1000

4. Disable transparent hugepage support

https://support.hpe.com/hpsc/doc/public/display?docId=mmr_kc-0111835

[centos@ip-172-31-39-235 ~]$ sudo -i
[root@ip-172-31-39-235 ~]# echo never > /sys/kernel/mm/transparent_hugepage/enabled
[root@ip-172-31-39-235 ~]# echo never > /sys/kernel/mm/transparent_hugepage/defrag
[root@ip-172-31-39-235 ~]# cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]
[root@ip-172-31-39-235 ~]#

[centos@ip-172-31-46-208 ~]$ sudo vi /boot/grub/menu.lst
add>>
transparent_hugepage=never

5. List your network interface configuration

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


6. Show that forward and reverse host lookups are correctly resolved
o For /etc/hosts, use getent

https://zetawiki.com/wiki/%EB%A6%AC%EB%88%85%EC%8A%A4_getent

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


o For DNS, use nslookup
not installed. can not find packages in centos mirror


7. Show the nscd service is running
[centos@ip-172-31-39-235 ~]$ yum install -y nscd
[centos@ip-172-31-39-235 ~]$ sudo service nscd start
Redirecting to /bin/systemctl start nscd.service

8. Show the ntpd service is running
[centos@ip-172-31-39-235 ~]$ yum install -y ntp
[centos@ip-172-31-39-235 ~]$ sudo service ntpd start
Redirecting to /bin/systemctl start ntpd.service

nscd : NIS/NS 를 사용할수 있게 하는 데몬. nscd는 실행중인 프로그램의 그룹을 살피고 패스워드를 변경하거나 다음 질의를 위해 결과를 캐시하는 데몬이다. 
ntpd : NTPv4데몬



Cloudera Manager Install Lab
Path B install using CM 5.15.x
The full rundown is here. You will have to modify your package repo to get the right
release. The default repo download always points to the latest version.
Use the documentation to complete the following objectives:
• Install a supported Oracle JDK on your first node

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
[root@ip-172-31-39-235 ~]# yum install -y openjdk

• Install a supported JDBC connector on all nodes
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