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
