# 1、参数设置

## 1、启动参数

~~~shell
mysqld --innodb-deadlock-detect=off --innodb_lock_wait_timeout=50
~~~



## 2、配置文件

修改my.cnf配置文件

~~~cnf
[mysqld]
basedir=/Volumes/Mac/develop/mysql-5.7.29-macos10.14-x86_64
datadir=/Volumes/Mac/develop/mysql-5.7.29-macos10.14-x86_64/data
general_log=on
general_log_file=/Volumes/Mac/develop/mysql-5.7.29-macos10.14-x86_64/log/run.log
innodb-deadlock-detect=off
~~~



## 3、运行时设置

~~~sql
SET [GLOBAL|SESSION] 系统变量名 = 值;
-- 例如
SET GLOBAL innodb_deadlock_detect = 'ON';
~~~



# Redo日志持久化策略

~~~shell
# 指定何时将事务日志刷到磁盘，默认为1。 
# 0表示每秒将"log buffer"同步到"os buffer"且从"os buffer"刷到磁盘日志文件中。 
# 1表示每事务提交都将"log buffer"同步到"os buffer"且从"os buffer"刷到磁盘日志文件中。 
# 2表示每事务提交都将"log buffer"同步到"os buffer"但每秒才从"os buffer"刷到磁盘日志文件中。
innodb_flush_log_at_trx_commit={0|1|2}
~~~

# BinLog日志持久化策略

~~~shell
# 表示每次事务的 binlog 都持久化到磁盘。
sync_binlog=1
~~~

# Innodb死锁等待超时时间

~~~shell
# 单位秒
innodb_lock_wait_timeout=50
~~~

# Innodb死锁主动回滚

~~~shell
innodb_deadlock_detect=ON
~~~

# Innodb changebuffer占bufferPool的大小

~~~shell
innodb_change_buffer_max_size=25
~~~



# Innodb统计消息持久化

~~~shell
# 设置为 on 的时候，表示统计信息会持久化存储。这时，默认的 N 是 20，M 是 10。
# 设置为 off 的时候，表示统计信息只存储在内存中。这时，默认的 N 是 8，M 是 16。
# InnoDB 默认会选择 N 个数据页，统计这些页面上的不同值，得到一个平均值，然后乘以这个索引的页面数，就得到了这个索引的基数
# 当变更的数据行数超过 1/M 的时候，会自动触发重新做一次索引统计
innodb_stats_persistent=on
~~~



# Innodb本地磁盘IO能力

~~~shell
innodb_io_capacity=200
~~~



该参数设置为磁盘的IOPS值，该值可以通过以下工具获取

~~~shell
fio -filename=$filename -direct=1 -iodepth 1 -thread -rw=randrw -ioengine=psync -bs=16k -size=500M -numjobs=10 -runtime=10 -group_reporting -name=mytest 
~~~

