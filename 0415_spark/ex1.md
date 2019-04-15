> preset
    
    catch up 5
    vi .bashrc
    마지막 두라인 # 제거 
    source .bashrc

> 기본 action 확인
```
[training@localhost ~]$ spark-shell
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.6.0
      /_/

Using Scala version 2.10.5 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_60)

scala> val myrdd = sc.textFile( "file:/home/training/training_materials/data/frostroad.txt")

scala> myrdd.count()
res2: Long = 23

scala> myrdd.collect()
res3: Array[String] = Array(Two roads diverged in a yellow wood,, And sorry I could not travel both, And be one traveler, long I stood, And looked down one as far as I could, To where it bent in the undergrowth;, "", Then took the other, as just as fair,, And having perhaps the better claim,, Because it was grassy and wanted wear;, Though as for that the passing there, Had worn them really about the same,, "", And both that morning equally lay, In leaves no step had trodden black., Oh, I kept the first for another day!, Yet knowing how way leads on to way,, I doubted if I should ever come back., "", I shall be telling this with a sigh, Somewhere ages and ages hence:, Two roads diverged in a wood, and I--, I took the one less traveled by,, And that has made all the difference.)
```

> weblogs file to hdfs
```
[training@localhost ~]$ ls ~/training_materials/data/weblogs/
2013-09-15.log  2013-10-22.log  2013-11-28.log  2014-01-04.log  2014-02-10.log
2013-09-16.log  2013-10-23.log  2013-11-29.log  2014-01-05.log  2014-02-11.log
2013-09-17.log  2013-10-24.log  2013-11-30.log  2014-01-06.log  2014-02-12.log
2013-09-18.log  2013-10-25.log  2013-12-01.log  2014-01-07.log  2014-02-13.log

[training@localhost ~]$ hdfs dfs -mkdir /loudacre

[training@localhost ~]$ hdfs dfs -ls /loudacre

drwxrwxrwx   - training supergroup          0 2019-04-14 19:55 /loudacre/accounts
drwxrwxrwx   - training supergroup          0 2019-04-14 19:55 /loudacre/accounts_parquet
-rw-rw-rw-   1 training supergroup      15191 2019-04-14 19:55 /loudacre/base_stations.tsv
drwxrwxrwx   - training supergroup          0 2019-04-14 19:55 /loudacre/kb

[training@localhost ~]$ hdfs dfs -put ~/training_materials/data/weblogs/ /loudacre/
```

> transformation
```
[training@localhost ~]$ spark-shell
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.6.0
      /_/

Using Scala version 2.10.5 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_60)
scala> sc.setLogLevel("ERROR")

scala> val logfiles="/loudacre/weblogs/*"
logfiles: String = /loudacre/weblogs/*

scala> val logsRDD = sc.textFile(logfiles)
logsRDD: org.apache.spark.rdd.RDD[String] = /loudacre/weblogs/* MapPartitionsRDD[1] at textFile at <console>:29

scala> val jpglogsRDD = logsRDD.filter( line => line.contains(".jpg"))
jpglogsRDD: org.apache.spark.rdd.RDD[String] = MapPartitionsRDD[2] at filter at <console>:31

scala> jpglogsRDD.take(10)
res3: Array[String] = Array(217.150.149.167 - 4712 [15/Sep/2013:23:56:06 +0100] "GET /ronin_s4.jpg HTTP/1.0" 200 5552 "http://www.loudacre.com"  "Loudacre Mobile Browser MeeToo 1.0", 104.184.210.93 - 28402 [15/Sep/2013:23:42:53 +0100] "GET /titanic_2200.jpg HTTP/1.0" 200 19466 "http://www.loudacre.com"  "Loudacre Mobile Browser MeeToo 2.0", 37.91.137.134 - 36171 [15/Sep/2013:23:39:33 +0100] "GET /ronin_novelty_note_3.jpg HTTP/1.0" 200 7432 "http://www.loudacre.com"  "Loudacre Mobile Browser iFruit 3", 177.43.223.203 - 90653 [15/Sep/2013:23:31:17 +0100] "GET /ifruit_3.jpg HTTP/1.0" 200 19578 "http://www.loudacre.com"  "Loudacre Mobile Browser Sorrento F31L", 19.250.65.76 - 44388 [15/Sep/2013:23:31:10 +0100] "GET /sorrento_f24l.jpg HTTP/1.0" 200 5730 "http://www.loudacre.com"  "Loudacre M...
scala> logsRDD.map(line => line.length).take(5)
res4: Array[Int] = Array(151, 143, 154, 147, 160)

scala> logsRDD.map(line => line.split(' ')).take(5)
res5: Array[Array[String]] = Array(Array(3.94.78.5, -, 69827, [15/Sep/2013:23:58:36, +0100], "GET, /KBDOC-00033.html, HTTP/1.0", 200, 14417, "http://www.loudacre.com", "", "Loudacre, Mobile, Browser, iFruit, 1"), Array(3.94.78.5, -, 69827, [15/Sep/2013:23:58:36, +0100], "GET, /theme.css, HTTP/1.0", 200, 3576, "http://www.loudacre.com", "", "Loudacre, Mobile, Browser, iFruit, 1"), Array(19.38.140.62, -, 21475, [15/Sep/2013:23:58:34, +0100], "GET, /KBDOC-00277.html, HTTP/1.0", 200, 15517, "http://www.loudacre.com", "", "Loudacre, Mobile, Browser, Ronin, S1"), Array(19.38.140.62, -, 21475, [15/Sep/2013:23:58:34, +0100], "GET, /theme.css, HTTP/1.0", 200, 13353, "http://www.loudacre.com", "", "Loudacre, Mobile, Browser, Ronin, S1"), Array(129.133.56.105, -, 2489, [15/Sep/2013:23:58:34, +0100...

scala> val ipsRDD = logsRDD.map(line => line.split(' ') (0))
ipsRDD: org.apache.spark.rdd.RDD[String] = MapPartitionsRDD[5] at map at <console>:31

scala> ipsRDD.take(5)
res6: Array[String] = Array(3.94.78.5, 3.94.78.5, 19.38.140.62, 19.38.140.62, 129.133.56.105)

scala> ipsRDD.take(10).foreach(println)
3.94.78.5
3.94.78.5
19.38.140.62
19.38.140.62
129.133.56.105
129.133.56.105
217.150.149.167
217.150.149.167
217.150.149.167
217.150.149.167

scala> ipsRDD.saveAsTextFile("/loudacre/iplist")
                                                                                
scala> val ip_user_RDD = logsRDD.map( line => line.replace(" - ","/")).map(line => line.split(' ') (0))
ip_user_RDD: org.apache.spark.rdd.RDD[String] = MapPartitionsRDD[8] at map at <console>:31

scala> ip_user_RDD.take(5)
res9: Array[String] = Array(3.94.78.5/69827, 3.94.78.5/69827, 19.38.140.62/21475, 19.38.140.62/21475, 129.133.56.105/2489)
```