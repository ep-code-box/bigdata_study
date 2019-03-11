conf 파일 내용
```
[training@localhost ~]$ cat flumber.conf 
# agent   name flumber
# source  name netc
#         type Netcat
#         Bind localhost
#         port 44444
# channel name no7
#         type Memory
#         capa 1000
#         tran 100    한번에 처리하는 량
# sink    name logk

flumber.sources  = netc
flumber.sinks    = logk
flumber.channels = no7

flumber.sources.netc.type = netcat
flumber.sources.netc.bind = localhost
flumber.sources.netc.port = 44444

flumber.sources.netc.channels = no7

flumber.channels.no7.type                = netcat
flumber.channels.no7.capacity            = 1000
flumber.channels.no7.transactionCapacity = 100

flumber.sinks.logk.channel    = no7

flumber.sinks.logk.type = logger
```
agent실행

다른 터미널에서는 접속 후 
hello, iam ep, can you hear me?  를 입력했다.
```
[training@localhost ~]$ flume-ng agent --conf /etc/flume-ng/conf --conf-file ~/flumber.conf --name flumber -Dflume.root.logger=INFO,console
Info: Sourcing environment configuration script /etc/flume-ng/conf/flume-env.sh
Info: Including Hadoop libraries found via (/usr/bin/hadoop) for HDFS access
Info: Excluding /usr/lib/hadoop/lib/slf4j-api-1.7.5.jar from classpath
Info: Excluding /usr/lib/hadoop/lib/slf4j-log4j12.jar from classpath
Info: Including HBASE libraries found via (/usr/bin/hbase) for HBASE access
Info: Excluding /usr/lib/hbase/bin/../lib/slf4j-api-1.7.5.jar from classpath
Info: Excluding /usr/lib/hbase/bin/../lib/slf4j-log4j12.jar from classpath
Info: Excluding /usr/lib/hadoop/lib/slf4j-api-1.7.5.jar from classpath
Info: Excluding /usr/lib/hadoop/lib/slf4j-log4j12.jar from classpath
Info: Excluding /usr/lib/hadoop/lib/slf4j-api-1.7.5.jar from classpath
Info: Excluding /usr/lib/hadoop/lib/slf4j-log4j12.jar from classpath
Info: Excluding /usr/lib/zookeeper/lib/slf4j-api-1.7.5.jar from classpath
Info: Excluding /usr/lib/zookeeper/lib/slf4j-log4j12-1.7.5.jar from classpath
Info: Excluding /usr/lib/zookeeper/lib/slf4j-log4j12.jar from classpath
Info: Including Hive libraries found via () for Hive access
+ exec /usr/java/default/bin/java -Xmx500m -Dflume.root.logger=INFO,console -cp '/etc/flume-ng/conf:/usr/lib/flume-ng/lib/*:/etc/hadoop/conf:/usr/lib/hadoop/lib/activation-1.1.jar:/usr/lib/hadoop/lib/apacheds-i18n-2.0.0-M15.jar:/usr/lib/hadoop/lib/apacheds-kerberos-codec-2.0.0-M15.jar:/usr/lib/hadoop/lib/api-asn1-api-1.0.0-M20.jar:/usr/lib/hadoop/lib/api-util-1.0.0-M20.jar:/usr/lib/hadoop/lib/asm-3.2.jar:/usr/lib/hadoop/lib/avro.jar:/usr/lib/hadoop/lib/aws-java-
...
...
...
-Djava.library.path=:/usr/lib/hadoop/lib/native:/usr/lib/hadoop/lib/native:/usr/lib/hbase/bin/../lib/native/Linux-amd64-64 org.apache.flume.node.Application --conf-file /home/training/flumber.conf --name flumber
2019-03-11 01:37:42,479 (lifecycleSupervisor-1-0) [INFO - org.apache.flume.node.PollingPropertiesFileConfigurationProvider.start(PollingPropertiesFileConfigurationProvider.java:61)] Configuration provider starting
2019-03-11 01:37:42,488 (conf-file-poller-0) [INFO - org.apache.flume.node.PollingPropertiesFileConfigurationProvider$FileWatcherRunnable.run(PollingPropertiesFileConfigurationProvider.java:133)] Reloading configuration file:/home/training/flumber.conf
...
...
...
2019-03-11 01:37:42,626 (lifecycleSupervisor-1-3) [INFO - org.apache.flume.source.NetcatSource.start(NetcatSource.java:155)] Source starting
2019-03-11 01:37:42,637 (lifecycleSupervisor-1-3) [INFO - org.apache.flume.source.NetcatSource.start(NetcatSource.java:169)] Created serverSocket:sun.nio.ch.ServerSocketChannelImpl[/127.0.0.1:44444]
2019-03-11 01:37:53,527 (SinkRunner-PollingRunner-DefaultSinkProcessor) [INFO - org.apache.flume.sink.LoggerSink.process(LoggerSink.java:94)] Event: { headers:{} body: 68 65 6C 6C 6F 0D                               hello. }
2019-03-11 01:38:15,545 (SinkRunner-PollingRunner-DefaultSinkProcessor) [INFO - org.apache.flume.sink.LoggerSink.process(LoggerSink.java:94)] Event: { headers:{} body: 69 61 6D 20 65 70 0D                            iam ep. }
2019-03-11 01:38:24,975 (SinkRunner-PollingRunner-DefaultSinkProcessor) [INFO - org.apache.flume.sink.LoggerSink.process(LoggerSink.java:94)] Event: { headers:{} body: 63 61 6E 20 79 6F 75 20 68 65 61 72 20 6D 65 3F can you hear me? }
```