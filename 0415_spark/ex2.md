## ex2
```py
# coding: utf-8
# Stub code to copy into Spark Shell

import xml.etree.ElementTree as ElementTree

# Optional: Set logging level to WARN to reduce distracting info messages
sc.setLogLevel("WARN")

# Given a string containing XML, parse the string, and 
# return an iterator of activation XML records (Elements) contained in the string

def getActivations(s):
    filetree = ElementTree.fromstring(s)
    return filetree.getiterator('activation')

# Given an activation record (XML Element), return the model name
def getModel(activation):
    return activation.find('model').text

# Given an activation record (XML Element), return the account number 
def getAccount(activation):
    return activation.find('account-number').text

actRDD = sc.wholeTextFiles("hdfs:/loudacre/activations/")
actRDD.take(1)
flat_actRDD = actRDD.flatMap(lambda (fname, xmldata): getActivations(xmldata))
rslt_actRDD = flat_actRDD.map(lambda act: (getAccount(act)+":"+getModel(act)) )
print rslt_actRDD.take(15)
rslt_actRDD.saveAsTextFile("hdfs:/loudacre/account-models")
```


## Bonus
```py
# [training@localhost spark-application]$ hdfs dfs -put $DEVDATA/devicestatus.txt /loudacre/
devRDD = sc.textFile("hdfs:/loudacre/devicestatus.txt")
# devRDD.take(2)
#[u'2014-03-15:10:10:20,Sorrento F41L,8cc3b47e-bd01-4482-b500-28f2342679af,7,24,39,enabled,disabled,connected,55,67,12,33.6894754264,-117.543308253',
# u'2014-03-15:10:10:20|MeeToo 1.0|ef8c7564-0a1a-4650-a655-c8bbd5f8f943|0|31|63|70|39|27|enabled|enabled|enabled|37.4321088904|-121.485029632']
# 19번쨰 오는건 무조건 딜리미터다. 
# 그리고 split으로 생성되는 애들은 데이터가 list라서
# LEN() 을 써서 14개로 파싱된 애들만 가져온다.
filRDD = devRDD.map(lambda data: data.split(data[19])).filter(lambda arr: len(arr) == 14)
# filRDD.take(1)
# 필터된 거에서 필요한 항목을 가져온다.
# 두번째 값이 제조사에 모델명이니 파싱해서 하나씩 가져온다.
dev1RDD = filRDD.map(lambda a: [a[0], a[1].split(' ')[0], a[1].split(' ')[1], a[2], a[12], a[13]])
dev1RDD.take(2)
#[[u'2014-03-15:10:10:20',  u'Sorrento',  u'F41L',  u'8cc3b47e-bd01-4482-b500-28f2342679af',  u'33.6894754264',  u'-117.543308253'],
# [u'2014-03-15:10:10:20',  u'MeeToo'  ,  u'1.0' ,  u'ef8c7564-0a1a-4650-a655-c8bbd5f8f943',  u'37.4321088904',  u'-121.485029632']]
dev1RDD.saveAsTextFile("hdfs:/loudacre/devicestatus_etl")
```