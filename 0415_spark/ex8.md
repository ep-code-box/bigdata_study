### sqoop을 통해 데이터 hdfs로 가져오기.

```r
[training@localhost ~]$ sqoop import \
> --connect jdbc:mysql://localhost/loudacre \
> --username training --password training \
> --table webpage \
> --target-dir /loudacre/webpage \
> --as-parquetfile
```

### pyspark 시작

```py
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 1.6.0
      /_/

Using Python version 2.7.8 (default, Nov 14 2016 05:07:18)
SparkContext available as sc, HiveContext available as sqlContext.
\ sqlcontext 선언.
In [1]: sqlContext
Out[1]: <pyspark.sql.context.HiveContext at 0x7f613f553450>
\ sqlContext를 사용해 hdfs 데이터 로드.
In [2]: webpageDF = sqlContext.read.load("/loudacre/webpage")
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/usr/lib/parquet/lib/parquet-hadoop-bundle-1.5.0-cdh5.7.0.jar!/shaded/parquet/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/lib/parquet/lib/parquet-pig-bundle-1.5.0-cdh5.7.0.jar!/shaded/parquet/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/lib/parquet/lib/parquet-format-2.1.0-cdh5.7.0.jar!/shaded/parquet/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/lib/hive/lib/hive-jdbc-1.1.0-cdh5.7.0-standalone.jar!/shaded/parquet/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/lib/hive/lib/hive-exec-1.1.0-cdh5.7.0.jar!/shaded/parquet/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [shaded.parquet.org.slf4j.helpers.NOPLoggerFactory]

In [3]: webpageDF.printSchema()
root
 |-- web_page_num: integer (nullable = true)
 |-- web_page_file_name: string (nullable = true)
 |-- associated_files: string (nullable = true)


In [4]: webpageDF.show(5)
+------------+--------------------+--------------------+
|web_page_num|  web_page_file_name|    associated_files|
+------------+--------------------+--------------------+
|          27|sorrento_f10l_sal...|theme.css,code.js...|
|          28|titanic_4000_sale...|theme.css,code.js...|
|          29|sorrento_f41l_sal...|theme3.css,code.j...|
|          30|titanic_deckchair...|theme1.css,code.j...|
|          31|meetoo_4.1_sales....|theme3.css,code.j...|
+------------+--------------------+--------------------+
only showing top 5 rows

\ 웹페이지넘버와 연관 파일들 컬럼만 따로 DataFrame 생성 
\ flatMapValues 를 쓰기 위해서 key-value가 되어야 한다.
In [5]: assocFilesDF = webpageDF.select(webpageDF.web_page_num, webpageDF.associ
   ...: ated_files)

In [6]: assocFilesDF.printSchema()
root
 |-- web_page_num: integer (nullable = true)
 |-- associated_files: string (nullable = true)


In [7]: assocFilesDF.show(5)
+------------+--------------------+
|web_page_num|    associated_files|
+------------+--------------------+
|          27|theme.css,code.js...|
|          28|theme.css,code.js...|
|          29|theme3.css,code.j...|
|          30|theme1.css,code.j...|
|          31|theme3.css,code.j...|
+------------+--------------------+
only showing top 5 rows

\ 생성된 데이터 프레임을 map을 통해 RDD로 생성.  (RDD처럼 map을 쓸수 있고 map의 리턴이 RDD라서 RDD로 바로 생성됨.)
In [8]: aFilesRDD = assocFilesDF.map(lambda row : (row.web_page_num, row.associa
   ...: ted_files))
\ RDD 의 flatMapValues를 통해 associated_files 쪼개기.
In [9]: aFilesRDD2 = aFilesRDD.flatMapValues(lambda filestring:filestring.split(
   ...: ','))
\ 쪼갠 RDD를 받을 새로운 DataFrame 생성.  쪼갠RDD를 assocFilesDF스키마로 생성해라.
In [10]: aFileDF = sqlContext.createDataFrame(aFilesRDD2, assocFilesDF.schema)

In [11]: aFileDF.printSchema()
root
 |-- web_page_num: integer (nullable = true)
 |-- associated_files: string (nullable = true)


In [12]: aFileDF.show(5)
+------------+-----------------+
|web_page_num| associated_files|
+------------+-----------------+
|          27|        theme.css|
|          27|          code.js|
|          27|sorrento_f10l.jpg|
|          28|        theme.css|
|          28|          code.js|
+------------+-----------------+
only showing top 5 rows

\ 쪼갠걸로 부족하다. 컬럼 이름을 ...files에서 ...file로 변경
In [13]: finalDF = aFileDF.withColumnRenamed('associated_files','associated_file
    ...: ')

In [14]: finalDF.printSchema()
root
 |-- web_page_num: integer (nullable = true)
 |-- associated_file: string (nullable = true)


In [15]: finalDF.show(5)
+------------+-----------------+
|web_page_num|  associated_file|
+------------+-----------------+
|          27|        theme.css|
|          27|          code.js|
|          27|sorrento_f10l.jpg|
|          28|        theme.css|
|          28|          code.js|
+------------+-----------------+
only showing top 5 rows

\ 다 확인 했으면 덮어쓰기로. hdfs의 /loudacre/webpage_files 에 저장
In [16]: finalDF.write.mode("overwrite").save("/loudacre/webpage_files")

In [17]: exit
```

### 저장된 데이터 확인

```r
# 일단 리스트 확인
[training@localhost ~]$ hadoop dfs -ls /loudacre/webpage_files/
DEPRECATED: Use of this script to execute hdfs command is deprecated.
Instead use the hdfs command for it.

Found 7 items
-rw-rw-rw-   1 training supergroup          0 2019-04-16 19:16 /loudacre/webpage_files/_SUCCESS
-rw-rw-rw-   1 training supergroup        360 2019-04-16 19:16 /loudacre/webpage_files/_common_metadata
-rw-rw-rw-   1 training supergroup       1415 2019-04-16 19:16 /loudacre/webpage_files/_metadata
-rw-rw-rw-   1 training supergroup        927 2019-04-16 19:16 /loudacre/webpage_files/part-r-00000-74daa8c8-4f44-46dd-971a-e7a8d868688c.gz.parquet
-rw-rw-rw-   1 training supergroup        915 2019-04-16 19:16 /loudacre/webpage_files/part-r-00001-74daa8c8-4f44-46dd-971a-e7a8d868688c.gz.parquet
-rw-rw-rw-   1 training supergroup        909 2019-04-16 19:16 /loudacre/webpage_files/part-r-00002-74daa8c8-4f44-46dd-971a-e7a8d868688c.gz.parquet
-rw-rw-rw-   1 training supergroup        923 2019-04-16 19:16 /loudacre/webpage_files/part-r-00003-74daa8c8-4f44-46dd-971a-e7a8d868688c.gz.parquet
# 로컬로 받아 두고.
[training@localhost ~]$ hadoop dfs -get /loudacre/webpage_files/part-r-00000-74daa8c8-4f44-46dd-971a-e7a8d868688c.gz.parquet ~/a.gz.parquet
DEPRECATED: Use of this script to execute hdfs command is deprecated.
Instead use the hdfs command for it.
# parquet-tools head 로 저장된 데이터 체크
[training@localhost ~]$ parquet-tools head a.gz.parquet 
web_page_num = 27
associated_file = theme.css

web_page_num = 27
associated_file = code.js

web_page_num = 27
associated_file = sorrento_f10l.jpg

web_page_num = 28
associated_file = theme.css

web_page_num = 28
associated_file = code.js
```
