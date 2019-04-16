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
devRDD = sc.textFile("hdfs:/loudacre/devicestatus.txt")
devRDD.take(2)
# 19번쨰 오는건 무조건 딜리미터다.
filRDD = devRDD.map(lambda data: data.split(data[19])).filter(lambda arr: len(arr) == 14)
filRDD.take(1)
dev1RDD = filRDD.map(lambda a: [a[0], a[1].split(' ')[0], a[1].split(' ')[1], a[2], a[12], a[13]])
dev1RDD.take(2)
dev1RDD.saveAsTextFile("hdfs:/loudacre/devicestatus_etl")
```