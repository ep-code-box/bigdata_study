```py
import sys
from pyspark import SparkContext
from pyspark.streaming import StreamingContext

# Given an RDD of KB requests, print out the count of elements
def printRDDcount(rdd): print "Number of KB requests: "+str(rdd.count())

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print >> sys.stderr, "Usage: StreamingLogs.py <hostname> <port>"
        sys.exit(-1)

    # get hostname and port of data source from application arguments
    hostname = sys.argv[1]
    port = int(sys.argv[2])

    # Create a new SparkContext
    sc = SparkContext()

    \# Create a new SparkStreamContext
    \# sc use, interval 1 second
    ssc = StreamingContext(sc, 1)

    # Set log level to ERROR to avoid distracting extra output
    sc.setLogLevel("ERROR")

    # TODO
    print "Stub not yet implemented"

    \# socket setting
    DS = ssc.socketTextStream(hostname, port)
    \# data filter, start with "KB"
    reqDS = DS.filter(lambda stream : "KB" in stream)
    \# check data
    # reqDS.foreachRDD(lambda data : pprint(data, 5))
    reqDS.pprint(5)
    \# printRDDcount call
    reqDS.foreachRDD(lambda RDD: printRDDcount(RDD))

    \# save file to text
    reqDS.saveAsTextFiles("hdfs:/loudacre/streamlog/kblogs")

    \# stream start
    ssc.start()
    ssc.awaitTermination()
```