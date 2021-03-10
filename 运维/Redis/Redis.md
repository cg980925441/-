# 1、描述

开源的基于内存的key-value存储系统，可用作数据库、缓存和消息中间件。



# 2、安装

~~~shell
# 下载
wget https://download.redis.io/releases/redis-6.0.10.tar.gz

# 编译
make 

# 清除编译
make distclean

# 安装,指定路径
make PREFIX=/opt/zanpocc/redis install

# 添加环境变量
echo "export REDIS_HOME=/opt/zanpocc/redis" >> /etc/profile
echo "export PATH=$PATH:$REDIS_HOME/bin"
source /etc/profile

# 安装为服务，utils
./install_server.sh

# 查看服务配置
vim /etc/init.d/redis_6379
~~~



# 3、数据类型

## 1、字符串





## 2、List

顺序（插入顺序）列表，可作为栈（同向）和队列（反向）

~~~shell
# 同向：栈
lpush k1 a b c d e f
lpop k1
# 反向：队列
lpush k1 a b c d e f
rpop k1

# 取值，列表,取所有元素
lrange k1 0 -1
# 列表取值
lindex k1 2
# 列表设置值
lset k1 3 x

# 删除值,整数表示从前开始，负数表示从后面开始
lrem k1 1 x
lrem k1 -1 x
# 删除首位
ltrim k1 0 -1

# 插入值
linsert k1 BEFORE a beforea

# 阻塞，单播队列
blpop xxoo 0
blpush xxoo hello


~~~



## 3、Hash

是一个key-value(key-value)的结构



~~~shell
# 插入单个
hset zhangsan name zs
# 插入多个
hmset zhangsan age 18 address shenzhen

# 取出
hget zhangsan name
hgetall zhangsan

# 数值操作
hincbyfloat zhangsan age 0.5

~~~



## 4、Set

无序、去重

~~~shell
# 插入多个
sadd s1 tomcat nginx redis

# 查看所有
smembers s1

# 交集
sinter s1 s2
sinterstore dest s1 s2

# 并集
sunion s1 s2
sunionstore dest s1 s2

# 差集
sdiff s1 s2
sdiffstore s1 s2

# 随机指定数量集合（不可重复）
srandmember s1 1
# 可重复
srandmember s1 -2

# 取出一个
spop s1
~~~



## 5、Sort Set

有顺序，不可重复

~~~shell
# 新增元素，带分值
zadd k1 8 apple 2 banana 3 orange

# 查看所有元素
zrange k1 0 -1
zrange k1 0 -1 withscores

# 取排序前n
zrange k1 0 1
zrevrange k1 0 1

# 根据分值区间取
zrangebyscore k1 3 8

# 根据元素取分值
zscore k1 apple

# 取出排名
zrank k1 apple

# 修改元素分值
zincrby k1 1 apple

# 交并差集
zunionstore unkey 2 k1 k2 weight 1 0.5 aggregate max

~~~

