# Spark study.
## http://bit.ly/2Z3HEBY

### RDD (Resilient Distributed Dataset)

  > 복구가능한 분산 데이터 셋 
    
    - 파일   ( From a file or set offiles )
    - 메모리 ( From datain memory )
    - RDD   ( From another RDD)
    - 위 3가지 특징을 지니고 변경 불가하다. 분산처리를 위해!!
    - lineage 가 있기에 Resilient 가 가능하다.

  > Action & Transformations

    - A : count() - 갯 수 리턴
    - A : take(n) - 첫 줄 부터 몇개.
    - A : collect() - 전체를 리턴한다.
    - A : saveAsTextFile(dir) - RDD를 text 파일로 저장
    - T : map(function) - 새 RDD에 데이터를 function을 통해 변조 저장
    - T : filter(function) - 새 RDD에 function 조건에 따라 저장. f는 boolean 리턴

  > lazy execution

    - 실제 데이터를 리턴하기 전까지 연산을 보류 한다.
    - transformation 은 액션이 아니기에 실 action 이 오기 전까지 lazy 한다.

  > Chaining Transformations

    - `.` 을 사용해서 파이프라이닝 처럼 사용할 수 있다.

  > RDD Lineage and toDebugString

    - RDD.toDebugString 은 RDD의 족보를 보여준다.(history)

  > 익명함수
    
    - python의 경우 lambda 를 사용한다. 
      ex: lambda x: x.add()
    - scala의 경우 더 간단하다.  input을 신경쓰지 않을 때 `_` 를 쓴다.
      ex: line => line.toUpperCase()
      ex: _.toUpperCase()

### Working with RDDs

  > RDD 데이터 형식

    - 뭐든 들어갈 수 있음. 완전 유연함.
    - 한줄은 collection, collection 안 하나의 데이터는 element
    - Pair RDDs : 키 벨류 로 구성된 RDD
    - Double RDDs : 숫자 데이터로 구성된 RDD, int가 아닌 double size를 위해

  > load to RDD

    - memory data를 바로 RDD로 만들때??
      : sc.parallelize( collection )
    - file에서 RDD를 만들때
      : sc.textFile( "myfile.txt")
      : sc.textFile( "mydata/")
      : sc.textFile( "mydata/*.log")
      : sc.textFile( "myfile1.txt, myfile2.txt") 
      : URI 를 통해  `file:`  or  `hdfs:` 등을 통해 경로 지정 가능.
      : load, save default 는 hdfs.
    - sc.hadoopFile : newAPIhadoopFile 파일 읽을때. 사용하는 클래스
    - rdd.saveAsHadoopFile : saveAsNewAPIhadoopFile 파일 저장할때 사용하는 클래스.
    - sc.wholeTextFiles (directory) : 디렉토리 내 모든 파일을 가져온다. 각파일은 각로우가 된다.
      : 파일주소, 파일내용들...
    
  > Single-RDD Transformations

    - flatMap : 한줄의 collection 을 flatMap 조건에 따라 여러 collection으로 나눈다.  
    - distinct : 중복을 제거 한다.
    - sort : 정열.

  > Multi-RDD Transformations

    - intersection : 두 RDD의 교집합 rdd1.intersection(rdd2)
    - union : 합치기  rdd1.union(rdd2)   union all과 다름. 그냥 union
    - zip : 두 RDD는 갯수가 동일해야 한다.
      rdd1.zip(rdd2) := (rdd1-1 , rdd2-1), (rdd1-2, rdd2-2), (rdd1-3, rdd2-3) ...
    - subtract : rdd1.subtract(rdd2) := rdd1 - rdd2

  > Other Operations

    - first : 첫줄만. element 리턴으로 RDD가 아님.
    - foreach : RDD의 element 별로 연산.
    - top(n) : 큰 순서대로 읽어옴. n개.

### Pair RDDs
 
  > 특징과 이유

    - key-value pair : can be any type.
    - Use with map-reduce algorithms !!

  > keyBy

    - function으로 뽑은 값을 key, 해당 collection을 value
      : sc.textFile(xxx).keyBy( function ())

  > flatMapValues

    - key, value 상태일때 사용 가능함. 튜플이 되어야해.
      : RDD.flatMapValues(lambda xx : xx.split(':'))
      : a, 1:2:3:4  =>  a, 1   a, 2   a, 3   a, 4

  > Map-Reduce in Spark
    
    - Map phase : map, flatMap, filter, keyBy
    - Reduce phase : reduceByKey, sortByKey, mean
      : RDD.reduceByKey ( lambda a, b : a + b )  
        -- a, b 는 각 collection 의 밸류 . 결과는 키에 연산된 값.
        -- 연산은 + 나 * 등등등. 순서가 완전 바뀌어도 무방한 케이스만....

  > Pair RDD Operations
    
    - countByKey : 리턴 map, 각 키별로 갯수 세어줌.
    - groupByKey : flatMapValue의 반대. 합쳐진 밸류는 콜랙션 형태가 된다. []
    - sortByKey : 걍 키 기준으로 정열
    - join : key 값 기준으로 매칭하여 두개의 RDD를 join한다.

  > Other Pair Operations

    - keys : RDD로 리턴 키값만
    - values : RDD로 리턴 벨류만
    - lookup(key) : key에 해당하는 벨류
    - joins. : leftOuterJoin, rightOuterJoin, fullOuterJoin
    - value_mapper : mapValues, flatMapValues
    
### with Apache Spark Applications.

  > in applicantion
  
    - make SparkContext. Using name sc
      : sc = SparkContext()
    - 종료시에는 sc.stop() 을 사용해서 메모리 해제 해준다.

  > resource manage

    - Hadoop YARN
      : 대부분 사용하고 있고. cluster resources를 다른 어플과 함께 쉐어링 한다. 
    - Spark Standalone
      : 설치와 수행이 쉽다.
      : 확장과 설정이 한정적이며 보안을 지원하지 않는다.
      : 학습, 테스트, 개발, 소규모에 적합하다.
    - Apache Mesos
      : Spark를 지원한 최초 플랫폼.

  > Running a Spark Application Locally
    
    - spark-submit --master 'local[n]'  
      : n은 스레드 갯수. [n]이 없으면 싱글. [*]은 코어가 지원하는 모든거.
    - python : spark-submit --master yarn-cluster [applFileName] [optionFileName]
    - scala  : spark-submit --master yarn-cluster --class [className] [applFileName] [optionFileName]
    - spark-submit options for clusters
      : --jars : Scala & Java Only.
      : --py-files : Python Only. 
      : --driver-java-options : JVM 쪽으로 넘기는 자바 옵션
      : --executor-memory : executor 별 메모리 할당. ( ex] 1000M, 2g )  default 1g
      : --packages : maven을 위한거라는데. 외부라이브러리 읽어오기.
    - Plus several YARN-specific options
      : --num-executors : 시작때의 executors의 수
      : --executor-cores : executor별 위치하는 코어수?
      : --queue : Yarn이 허용하는 큐의 수.
    - 다른 옵션을 보고 플땐
      : --help

### Configuring Apache Spark Application

  > properties

    - spark.master
    - spark.app.name
    - spark.local.dir        default  /tmp  셔플이 진행되는 동안 사용하는 폴더
    - spark.ui.port          default  4040
    - spark.executor.memory  default  1G
    - spark.driver.memory    default  1G

    - spark-submit --conf spark.executor.cores=4   
    - spark-submit --properties-file filename    default SPARK_HOME/conf/spark-defaults.conf
      : key value 형태로 저장.

  > logging

    - 하둡 실행중 어플들 보기.
      : $ yarn application -list
    - 위 명령으로 appid찾아서 로그 확인
      : $ yarn logs -applicationId <appid>
    - spark debug 세팅 파일
      : SPARK_HOME/conf/log4j.properties

### Parallel Processing in Apache Spark

  > file partitioning 
    
    - sc.textFile( file, partitions)
      : 클러스터는 파티션 2, 로컬의 경우 파티션 1  이 기본.
    - sc.wholeTextFiles( dir, partitions )
      : foreachPartition  파티션별 반복하는 명령
      : mapPartitions ??
      : mapPartitionsWithIndex  위와 같으나. 파티션의 인덱스 포함.
    - 병렬 처리 가능한 연산
      : map, flatMap, filter ...
    - 리파티션이 처리되는 연산
      : reduceByKey, sortByKey, join, groupByKey ...

  > application : 아래 잡들이 모이면 하나의 어플이 된다.
  >> job : 결과를 내기 위한 그룹. 스테이지가 모여 job이 된다.
  >>> stage : 테스트의 집합이며. 다음 스테이지를 가기위해 가장 느린 테스크가 종료되어야 넘거 갈 수 있다. 내부 테스크는 병렬 수행 가능
  >>>> task : 하나의 executor에 단위 업무를 전달한다.
  
  > DAG(Directed Acyclic Graph)

    - Narrow dependencies
    - Wide dependencies
    - RDD.toDebugString()  을 써서 DAG를 볼 수 있다.

  > Controlling the Level of Parallelism

    - 일부 연산은 마지막 항목에 파시션을 선언 할 수 있다.
    - spark.default.parallelism 10  인데 수정 가능하다.

### RDD Persistence

  > persistence

    - 기본적으로 자바의 힙 메모리를 반반 나눠 cash와 persistence 로 쓴다.
    - cash는 빈번하게 삭제 가능한 것이며 persistence는 남아 있다.
    - 용량이 가득 차면 가장 오래된 것을 버린다.

  > Persistence and Fault-Tolerance

    - lineage를 통해 resiliency 를 유지한다.

  > Persistence Levels

    - 기본적으로 persist 메소드는 메모리에만 데이터를 저장한다.
    - storage levels 옵션을 통해. 아래에 저장한다.
      : Storage location ( memory or disk )
        >> MEMORY_ONLY       <<-- Scala Default
        >> MEMORY_AND_DISK
        >> DISK_ONLY
      : Format in memory
        >> MEMORY_ONLY_SER   <<-- Python Default
        >> MEMORY_AND_DISK_SER
      : Partition replication
        >> DISK_ONLY_2
        >> MEMORY_AND_DISK_2
        >> MEMORY_ONLY_2
        >> MEMORY_AND_DISK_SER_2
        >> MEMORY_ONLY_SER_2
    - 심플하게는 걍 CASHE() 로 쓰기도 한다.

  > when where

    - memory only : 최고의 퍼포먼스를 위해!
    - disk : io 시간이 다시 계산하는 시간보다 짧을 때.
    - replication : net io 전체가 다시 계산하는 것보다 짧을 때.

  > change persistence

    - RDD.unpersist() -> RDD.persist()

### Data Frames and Apache Spark SQL

  > Data Frame
    
    - spark context를 hive context로 랩핑해서 사용한다.
    - 기본적으로는 RDD와 유사.
    - DataFrames 생성은 아래와 같다.
      : 다른 데이터 스트럭쳐
      : 다른 RDD
      : 쿼리나 오퍼레이션을 통해
      : 프로그램으로 정의된 스키마를 통해

  > Read DataFrame

    - convenience function
      : json, parquet, orc   (파일네임)
      : table(hive-tablename)
      : jdbc(url, table, options)
    - manual read
      : sqlContext.read.format().option(),schema().load()
      : format - 데이터 타입. json 등등
      : option - 키 벨류로 입력한다. format에 따라 달라진다.
      : schema - 데이터 원본이 아닌 다른 스키마를 쓸때 사용.
    
  > Dataframe Basic operation

    - schema / printSchema : return schema / display on tree type
    - cashe / persist : 디스크나 메모리에 저장.
    - columns : 컬럼의 이름을 리턴.
    - dtypes : 컬럼 이름과 데이터 타입을 쌍으로 리턴한다.
    - explain : 디버그 인포메이션을 출력.

  > Working with Data in a DataFrame
   
    - Queries : Creat a new DataFame
      : RDD 처럼 변형 불가하고. RDD TransFormation과 유사하다.
      : RDD 트랜스폼 처럼 체인 처리 할수 있다.
      : distinct, join, limit, select, where(filter), 
    - Actions : Driver로 데이터를 반환한다.
      : lazy를 깨는 트리거!?
      : collect - all rows.
      : take(n) / show(n) - first to n rows. show is display.
      : count - total row number return.

  > Save Dataframe
    
    - 리드와 같이 콘비니언 제공 있음.
      : jdbc, json, parquet, orc, text(single column only), saveAsTable (hive context only)
    - DF.write.format(),mode().partitionBy().saveAsTable().save()
  
  > DF <-> RDD

    - RDD = DF.rdd
    - DF = sqlContext.createDataFrame(RDD, SCHEMA)

### Spark Streaming.

  > Use cases
   
    - Continuous ETL
    - Website monitoring
    - Fraud detection
    - Ad monetization
    - Social media analysis
    - Financial market trends

  > DStream ( Discretized Stream )

    - Spark Stream을 통해 들어온 조각조각?
    - sc 선언 -> ssc(sc, time_interval) 선언 -> stream 처리 선언( RDD 처리와 동일 ) -> ssc.start() -> ssc.awaitTermination()

  > Data source

    - ssc.socketTextStream(hostName, port)
    - network
      : Sockets, Flume, Akka Actors, Kafka, ZeroMQ, or Twitter
    - Files : HDFS 디렉토리를 모니터링 해서 가져올 수 있음.

  > DStream Operations

    - Transformations
      : map, flatMap, filter
      : Pair transform. -reduceByKey, groupByKey, join
      : 그 외 함수는  DS.transform( lambda RDD : RDD.transAPI ) 로 쓴다.
      : .transform 은 RDD 포인터를 넘겨 주기 때문에 사용 가능해짐.
    - Output operations
      : Console - pprint > 10개의 데이터를 보여준다.
      : File output - saveAsTextFiles (txt) / saveAsObjectFiles (seq)
      : Executing other Functions - foreachRDD( lambda (RDD,optional time) : function() ) time stamp 를 활용 할 수 있다.

  > in Application

    - included Spark Streaming library
    - and you need source library
    - 최소 2개의 thread가 필요하다.
      : DStream을 만드는 thread가 필요하고, 그 DStream을 처리하는 thread가 필요하다. 그래서 최소 2개.
    - 중단 되었을때 데이터는 버려진다. 그래서 kafka 채널등을 통해 누락 되는 데이터 없도록 하는 방안이 있다.

### Processing Multiple Batches

  > 멀티 배치 오퍼레이션.

    - Slice : A to B 구간.
      : DStream.slice(fromTime, toTime)
      : StreamingContext.remeber(duration)
      : check point 는 퍼시스트랑 다르게 리니지를 날려버린다.
      : .updateStateByKey - key값을 기준으로 업데이트 해준다.
    - State : origin to last
    - Windows : view time size.
      : reduceByKeyAndWindow( 리듀스 문법, window size, interval)

### Streaming Data Sources

  > flafka 실습.

## Data processing

  > PageRank 알고리즘.
    - 정의 : http://www.emh.co.kr/content.pl?google_pagerank_citation_ranking
    - 프로세싱.
      1. 각 페이지는 랭크 1을 가진다.
      2. 각 페이지는 나가는 링크(b) 만큼 자신의 랭크(a)를 나누어 준다.
        : (C)ontrib = a/b
      3. 새로운 랭크는 받은 C를 모두 합치고, sum(C)*.85+.15 를 한다.
      4. 반복한다.