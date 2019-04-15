# Spark study.

### RDD (Resilient Distributed Dataset)

  > 복구가능한 분산 데이터 셋 
    
    - 파일   ( From a file or set offiles )
    - 메모리 ( From datain memory )
    - RDD   ( From another RDD)
    
#####위 3가지 특징을 지니고 변경 불가하다. 분산처리를 위해!!

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

    - '.' 을 사용해서 파이프라이닝 처럼 사용할 수 있다.

  > RDD Lineage and toDebugString

    - RDD.toDebugString 은 RDD의 족보를 보여준다.(history)

  > 익명함수
    
    - python의 경우 lambda 를 사용한다. 
      ex: lambda x: x.add()
    - scala의 경우 더 간단하다.  input을 신경쓰지 않을 때 _를 쓴다.
      ex: line => line.toUpperCase()
      ex: _.toUpperCase()

