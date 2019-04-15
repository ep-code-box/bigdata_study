# Spark study.

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

