## CountJPGs.py

> 수행하기전 파이스파크 기본을 쥬피터로 돌렸던걸 다시 iPython으로 돌린다.

```py
import sys
from pyspark import SparkContext

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print >> sys.stderr, "Usage: CountJPGs.py <logfile>"
        exit(-1)
    
    sc = SparkContext()
    sc.setLogLevel("ERROR")

    # Replace this line with your code:    
    # print("TODO: complete this exercise")

    # get files by arg
    # logfiles = "hdfs:/loudacre/weblogs/*"
    logfiles = sys.argv[1]
    logsRDD  = sc.textFile(logfiles)
    
    # filter jpg logs  and count it
    jpgCount   = logsRDD.filter( lambda line: ".jpg" in line ).count()
    # is 64978
    print("jpgCount : ",jpgCount)

    sc.stop()
```    