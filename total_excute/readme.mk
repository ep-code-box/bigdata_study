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

1. Check vm.swappiness on all your nodes

https://zetawiki.com/wiki/%EB%A6%AC%EB%88%85%EC%8A%A4_swappiness

 개요
swappiness
vm.swappiness
스왑 활용도, 스와핑 활용도, 스와피니스
리눅스 커널 속성 중 하나
스왑메모리 활용 수준 조절
스왑 사용의 적극성 수준
2 값 설명
값의 범위: 0 ~ 100 (기본값: 60)
값	설명
vm.swappiness = 0	스왑 사용안함[1]
vm.swappiness = 1	스왑 사용 최소화
vm.swappiness = 60	기본값
vm.swappiness = 100	적극적으로 스왑 사용
→ 메모리 여유가 충분할 때 성능향상을 위해 vm.swappiness = 10 정도를 권고하는 경우가 있음
3 확인
[root@zetawiki ~]# sysctl vm.swappiness
vm.swappiness = 60
[root@zetawiki ~]# sysctl -a | grep swappiness
vm.swappiness = 60
[root@zetawiki ~]# cat /proc/sys/vm/swappiness
60
4 변경
즉시 변경 (재부팅시 초기화됨)
즉시 변경하는 방법은 아래와 같이 3가지가 있으나, /etc/sysctl.conf에 등록되지 않으면 재부팅 후 원상복구된다.

[root@zetawiki ~]# sysctl vm.swappiness=40
vm.swappiness = 40
[root@zetawiki ~]# sysctl -w vm.swappiness=40
vm.swappiness = 40
[root@zetawiki ~]# echo 40 > /proc/sys/vm/swappiness
[root@zetawiki ~]# sysctl vm.swappiness
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

[centos@ip-172-31-39-235 ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

[centos@ip-172-31-39-235 ~]$ getent hosts
127.0.0.1       localhost localhost.localdomain localhost4 localhost4.localdomain4
127.0.0.1       localhost localhost.localdomain localhost6 localhost6.localdomain6
172.31.39.235   t4h1
172.31.46.208   t4h2
172.31.46.141   t4h3
172.31.42.115   t4h4
172.31.46.235   t4h5

o For DNS, use nslookup
not installed. can not find packages in centos mirror

7. Show the nscd service is running
[centos@ip-172-31-39-235 ~]$ yum install nscd
[centos@ip-172-31-39-235 ~]$ sudo service nscd start
Redirecting to /bin/systemctl start nscd.service

8. Show the ntpd service is running
[centos@ip-172-31-39-235 ~]$ yum install ntp
[centos@ip-172-31-39-235 ~]$ sudo service ntpd start
Redirecting to /bin/systemctl start ntpd.service

nscd : NIS/NS 를 사용할수 있게 하는 데몬. nscd는 실행중인 프로그램의 그룹을 살피고 패스워드를 변경하거나 다음 질의를 위해 결과를 캐시하는 데몬이다. 
ntpd : NTPv4데몬

