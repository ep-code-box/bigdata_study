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
# A.Upload the devicestatus.txtfile to HDFS.
# hdfs dfs -put 을 통해 hdfs에 업로드하고
# 가능하면 uri를 붙여 데이터를 읽어 오자.

# [training@localhost spark-application]$ hdfs dfs -put $DEVDATA/devicestatus.txt /loudacre/
devRDD = sc.textFile("hdfs:/loudacre/devicestatus.txt")

# devRDD.take(2)
#[u'2014-03-15:10:10:20,Sorrento F41L,8cc3b47e-bd01-4482-b500-28f2342679af,7,24,39,enabled,disabled,connected,55,67,12,33.6894754264,-117.543308253',
# u'2014-03-15:10:10:20|MeeToo 1.0|ef8c7564-0a1a-4650-a655-c8bbd5f8f943|0|31|63|70|39|27|enabled|enabled|enabled|37.4321088904|-121.485029632']

# B.Determinewhichdelimitertouse(hint:thecharacteratposition19isthe first use of thedelimiter).
# C.Filteroutanyrecordswhichdonotparsecorrectly(hint:eachrecordshould have exactly 14values).
# 19번째 첫번째 delimeter가 있다. 즉 그걸로 parsing 하자.
# 파싱 후 정상적으로 파싱되었다면 14개가 있을 것이다.
# 배열의 길이가 14인 것들로만 추려 내자.

filRDD = devRDD.map(lambda data: data.split(data[19])).filter(lambda arr: len(arr) == 14)

# filRDD.take(1)

# D.Extractthedate(firstfield),model(secondfield),deviceID(thirdfield),and latitudeandlongitude(13thand14thfieldsrespectively).
# E.Thesecondfieldcontainsthedevicemanufacturerandmodelname(suchas RoninS2).Splitthisfieldbyspacestoseparatethemanufacturerfromthe model (for example, manufacturer Ronin, model S2). Keep just the manufacturername.
# 배열은 0부터 시작하니.  1,2,3,13,14 는 배열의 0,1,2,12,13 이 된다.
# 그리고 배열 1번지에 있는 데이터는 split을 통해 제조사와 모델로 각각 가져온다.
# 따로 튜플로 처리할 필요 없으니 []로 모두 묶어준다.

dev1RDD = filRDD.map(lambda a: [a[0], a[1].split(' ')[0], a[1].split(' ')[1], a[2], a[12], a[13]])

#dev1RDD.take(2)
#[[u'2014-03-15:10:10:20',  u'Sorrento',  u'F41L',  u'8cc3b47e-bd01-4482-b500-28f2342679af',  u'33.6894754264',  u'-117.543308253'],
# [u'2014-03-15:10:10:20',  u'MeeToo'  ,  u'1.0' ,  u'ef8c7564-0a1a-4650-a655-c8bbd5f8f943',  u'37.4321088904',  u'-121.485029632']]

# F.Savetheextracteddatatocomma-delimitedtextfilesinthe/loudacre/devicestatus_etldirectory on HDFS.G.Confirmthatthedatainthefile(s)wassavedcorrectly.
# saveAsTextFile을 통해 hdfs에 저장한다.
dev1RDD.saveAsTextFile("hdfs:/loudacre/devicestatus_etl")
```