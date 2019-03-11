1.
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

2.

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

3.

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