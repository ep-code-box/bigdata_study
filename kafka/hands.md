#토픽 만들기 이름을 weblogs로 한다.
```
kafka-topics --create \
--zookeeper localhost:2181 \
--replication-factor 1 \
--partitions 1 \
--topic weblogs
```

#만들어진 토픽 확인.
```
kafka-topics --list \
--zookeeper localhost:2181
```

#토픽 상세???
```
kafka-topics --describe weblogs \
--zookeeper localhost:2181
```

#원래는 직접 java로 짜야한다네
```
kafka-console-producer \
--broker-list localhost:9092 \
--topic weblogs
```

```
test weblog entry 1
```

```
kafka-console-consumer \
--zookeeper localhost:2181 \
--topic weblogs \
--from-beginning
```