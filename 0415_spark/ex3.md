## ex3
```py
# coding: utf-8
logfiles="hdfs:/loudacre/weblogs/*"
logsRDD = sc.textFile(logfiles)
userRDD = logsRDD.map( lambda lines : (lines.split(' ')[2], 1))
userRDD.take(2)
countByUserRDD = userRDD.reduceByKey(lambda v1,v2 : v1+v2)
countByUserRDD.take(2)
cBKRDD = countByUserRDD.map(lambda (k,v) : (v,k))
cBKRDD.take(3)
cBKRDD = countByUserRDD.map(lambda (k,v) : (v,k)).countByKey()
print cBKRDD
userIpRDD = logsRDD.map( lambda lines : (lines.split(' ')[2], lines.split(' ')[0]))
userIpRDD.take(2)
userIpsRDD = userIpRDD.groupByKey()
userIpsRDD.take(2)
accounts="hdfs:/loudacre/accounts/*"
accountRDD = sc.textFile(accounts)
accountRDD.take(2)
kaRDD = accountRDD.keyBy(lambda data : data.split(',')[0])
kaRDD.take(2)
joinRDD = kaRDD.join(countByUserRDD)
joinRDD.take(2)
rsltRDD = joinRDD.map(lambda (k,v): (k, v[1], v[0].split(',')[3], v[0].split(',')[4]))
rsltRDD.take(2)
```