====flafka config file====
```
# spooldir_kafka.conf: A Spooling Directory Source with a Kafka Sink
# Name the components on this agent
agent1.sources = webserver-log-source
agent1.sinks = kafka-sink
agent1.channels = memory-channel

# Configure the source
agent1.sources.webserver-log-source.type = spooldir
agent1.sources.webserver-log-source.spoolDir = /flume/weblogs_spooldir
agent1.sources.webserver-log-source.channels = memory-channel

# 싱크를 카프카로. 토픽은 웹로그.
# Configure the sink
agent1.sinks.kafka-sink.type = org.apache.flume.sink.kafka.KafkaSink
agent1.sinks.kafka-sink.topic = weblogs
agent1.sinks.kafka-sink.brokerList = localhost:9092
agent1.sinks.kafka-sink.batchSize = 20
agent1.sinks.kafka-sink.channel = memory-channel

# Use a channel which buffers events in memory
agent1.channels.memory-channel.type = memory
agent1.channels.memory-channel.capacity = 100000
agent1.channels.memory-channel.transactionCapacity = 1000
```

플럼 뉴제네 에이전트 실행.
```
flume-ng agent --conf /etc/flume-ng/conf \
--conf-file $DEVSH/exercises/flafka/spooldir_kafka.conf \
--name agent1 -Dflume.root.logger=INFO,console
```

주키퍼를 통해???? 웹로직 토픽 받아온다.
```
kafka-console-consumer \
--zookeeper localhost:2181 \
--topic weblogs
```

이거는 spooldir 을 위한 커맨드
```
$DEVSH/exercises/flume/copy-move-weblogs.sh \
/flume/weblogs_spooldir
```