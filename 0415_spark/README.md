# Spark study.

## RDD (Resilient Distributed Dataset)

  - __복구가능한 분산 데이터 셋__
    - 파일   ( From a file or set offiles )
    - 메모리 ( From datain memory )
    - RDD   ( From another RDD)

  - Action & Transformations
    - A : count() - 갯 수 리턴
    - A : take(n) - 첫 줄 부터 몇개.
    - A : collect() - 전체를 리턴한다.
    - A : saveAsTextFile(dir) - RDD를 text 파일로 저장
    - T : map(function) - 새 RDD에 기존 RDD의 데이터를 function을 통해 변조 저장
    - T : filter(function) - 새 RDD에 function 조건에 따라 저장. f는 boolean 리턴