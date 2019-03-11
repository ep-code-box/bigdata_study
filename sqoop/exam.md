1. eval을 사용하여 sql을 던지도록 한다.
   promt에 바로 출력된다.
   출력된 정보를 보고.
   필요컬럼을 셋팅하고. (columns)
   넣을 위치를 정한다. (target-dir in hdfs)
   필드 구분자는 \t로 셋팅한다. (fields-terminated-by)

```
sqoop eval \
--connect jdbc:mysql://localhost/loudacre \
--username training --password training \
--query 'describe accounts'

sqoop import \
--connect jdbc:mysql://localhost/loudacre \
--username training --password training \
--table accounts \
--columns "acct_num, first_name, last_name" \
--target-dir /loudacre/accounts/user_info \
--fields-terminated-by "\t"
```

2. parquet으로 저장하기 위해 as-parquetfile을 사용하고.
   저장 방식을 snappy로 하기 위해 코댁을 지정했다.

```
sqoop import \
--connect jdbc:mysql://localhost/loudacre \
--username training --password training \
--table accounts \
--columns "acct_num, first_name, last_name" \
--target-dir /loudacre/accounts/user_compressed \
--fields-terminated-by "\t" \
--compression-codec org.apache.hadoop.io.compress.SnappyCodec \
--as-parquetfile
```
   parquet 데이터는 바이너리로   parquet-tools 로 조회 할 수 있다.
```
[training@localhost ~]$ parquet-tools head hdfs://localhost/loudacre/accounts/user_compressed
acct_num = 64881
first_name = Virginia
last_name = Etter

acct_num = 64882
first_name = Thomas
last_name = Jones

acct_num = 64883
first_name = Jennifer
last_name = Spangler

acct_num = 64884
first_name = Kathleen
last_name = Blubaugh

acct_num = 64885
first_name = Daniel
last_name = Wells
```

3. 이번에는 일반 저장이라 단순 compress 셋팅. 
   추가로 CA 주에 사는 애들만 모으기 위해 where를 사용함. 
   단 where는 옵션명.  뒤에 ""를 사용해 where절을 작성한다.

```
sqoop import \
--connect jdbc:mysql://localhost/loudacre \
--username training --password training \
--table accounts \
--columns "acct_num, first_name, last_name" \
--target-dir /loudacre/accounts/CA \
--fields-terminated-by "\t" \
--where " state='CA'" \
--compress \
--as-parquetfile
```

```
training@localhost ~]$ parquet-tools head hdfs://localhost/loudacre/accounts/CA
acct_num = 64881
first_name = Virginia
last_name = Etter

acct_num = 64882
first_name = Thomas
last_name = Jones

acct_num = 64883
first_name = Jennifer
last_name = Spangler

acct_num = 64884
first_name = Kathleen
last_name = Blubaugh

acct_num = 64887
first_name = Marcia
last_name = Hall
```