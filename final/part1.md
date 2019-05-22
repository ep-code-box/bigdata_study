# part1



#### pre setting
```
[centos@ip-172-31-2-98 ~]$ sudo useradd -u 3800 training
[centos@ip-172-31-2-98 ~]$ sudo passwd training
Changing password for user training.
New password:
BAD PASSWORD: The password contains the user name in some form
Retype new password:
passwd: all authentication tokens updated successfully.
[centos@ip-172-31-2-98 ~]$ sudo groupadd skcc
[centos@ip-172-31-2-98 ~]$ sudo gpasswd -a training skcc
Adding user training to group skcc
[centos@ip-172-31-2-98 ~]$ sudo usermod -aG wheel training
[centos@ip-172-31-2-98 ~]$ getent hosts
127.0.0.1       localhost localhost.localdomain localhost4 localhost4.localdomain4
127.0.0.1       localhost localhost.localdomain localhost6 localhost6.localdomain6
15.164.131.198  master01.cdhcluster.com mn1
15.164.33.193   util01.cdhcluster.com util01
15.164.75.71    data01.cdhcluster.com dn1
52.78.237.141   data02.cdhcluster.com dn2
54.180.14.231   data03.cdhcluster.com dn3
[centos@ip-172-31-2-98 ~]$ sudo vi /etc/hosts
[centos@ip-172-31-2-98 ~]$ getent hosts
127.0.0.1       localhost localhost.localdomain localhost4 localhost4.localdomain4
127.0.0.1       localhost localhost.localdomain localhost6 localhost6.localdomain6
172.31.2.98     master01.cdhcluster.com mn1
172.31.9.124    util01.cdhcluster.com util01
172.31.3.215    data01.cdhcluster.com dn1
172.31.1.152    data02.cdhcluster.com dn2
172.31.14.52    data03.cdhcluster.com dn3
[centos@ip-172-31-2-98 ~]$ df -Th
Filesystem     Type      Size  Used Avail Use% Mounted on
/dev/nvme0n1p1 xfs       100G  1.2G   99G   2% /
devtmpfs       devtmpfs  7.6G     0  7.6G   0% /dev
tmpfs          tmpfs     7.6G     0  7.6G   0% /dev/shm
tmpfs          tmpfs     7.6G   17M  7.6G   1% /run
tmpfs          tmpfs     7.6G     0  7.6G   0% /sys/fs/cgroup
tmpfs          tmpfs     1.6G     0  1.6G   0% /run/user/1000
[centos@ip-172-31-2-98 ~]$ yum repolist
Loaded plugins: fastestmirror
Determining fastest mirrors
 * base: mirror.kakao.com
 * epel: d2lzkl7pfhq30w.cloudfront.net
 * extras: mirror.kakao.com
 * updates: mirror.kakao.com
repo id                                         repo name                                                                     status
!base/7/x86_64                                  CentOS-7 - Base                                                               10,019
*!epel/x86_64                                   Extra Packages for Enterprise Linux 7 - x86_64                                13,190
!extras/7/x86_64                                CentOS-7 - Extras                                                                413
!updates/7/x86_64                               CentOS-7 - Updates                                                             1,945
repolist: 25,567
[centos@ip-172-31-2-98 ~]$ cat /etc/passwd | grep training
training:x:3800:3800::/home/training:/bin/bash
[centos@ip-172-31-2-98 ~]$ cat /etc/group | grep skcc
skcc:x:3801:training
[centos@ip-172-31-2-98 ~]$ getent group | grep skcc
skcc:x:3801:training
[centos@ip-172-31-2-98 ~]$ getent passwd training
training:x:3800:3800::/home/training:/bin/bash
[centos@ip-172-31-2-98 ~]$ getent group skcc
skcc:x:3801:training
```

#### mysql to hive, hive to mysql
```
sqoop import \
    --connect jdbc:mysql://util01/test \
    --table authors \
    --target-dir /user/training/authors \
    --delete-target-dir \
    --username training \
    --password training \
    --fields-terminated-by ","

sqoop import \
    --connect jdbc:mysql://util01/test \
    --table posts \
    --target-dir /user/training/posts \
    --delete-target-dir \
    --username training \
    --password training \
    --fields-terminated-by ","
```

```sql
CREATE EXTERNAL TABLE AUTHORS (
  id           int    
, first_name   STRING
, last_name    STRING
, email        STRING
, birthdate    STRING 
, added        timestamp
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION '/user/training/authors'

CREATE TABLE posts (
  id            int    
, author_id     int    
, title         STRING 
, description   STRING 
, content       text   
, date          date   
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION '/user/training/posts'
```

```sql
SELECT A.id `id`
     , A.first_name `fname`
     , a.last_name  `Lname`
     , count(1)     `num_posts`
  FROM authors AS A
  JOIN POSTS   AS P ON (A.ID = P.author_id)
 GROUP BY a.id, a.first_name, a.last_name
-- result save useing hue 
```

```
sqoop export --connect "jdbc:mysql://util01/test"  \
             --username training \
             --password training \
             --table result \
             --export-dir /user/training/results \
             --input-fields-terminated-by "\t" \
```