~~~shell
# Server
redis_version:5.0.9                # Redis 服务器版本
redis_git_sha1:00000000            # Git SHA1
redis_git_dirty:0                  # Git脏标志符
redis_build_id:544ec503bcbee8b6    # 内部版本号
redis_mode:standalone              # 运行模式 单机还是集群
os:Darwin 17.7.0 x86_64            # 服务器的宿主操作系统
arch_bits:64                       # 体系结构（32位或者64位）
multiplexing_api:kqueue            # Redis使用的事件循环机制
atomicvar_api:atomic-builtin       # 原子处理api
gcc_version:4.2.1                  # 用于编译Redis服务器的GCC编译器的版本号
process_id:411                     # 务器进程的PID
run_id:e8bf4443cdd6696036e07c4a65d64e6916a6a79e  # Redis 服务器的随机标识符（用于 Sentinel 和集群）
tcp_port:6379                      # TCP/IP 监听端口
uptime_in_seconds:29924            # redis server启动的时间(单位秒)
uptime_in_days:0                   # redis server启动的时间(单位天)
hz:10                              # redis内部调度(进行关闭timeout的客户端，删除过期key等等)频率，程序规定serverCron每秒运行10次
configured_hz:10                   # 服务器的已配置频率设置
lru_clock:9421068                  # 自增的时钟，用于LRU管；该时钟100ms(hz=10,因此每1000ms/10=100ms执行一次定时任务)更新一次
executable:/usr/local/opt/redis/bin/redis-server  # 服务器可执行文件的路径
config_file:/usr/local/etc/redis.conf             # redis配置文件的路径

# Clients
connected_clients:1                # 客户端已连接的数量(不包括通过从属服务器连接的客户端)
client_recent_max_input_buffer:2   # 当前客户端最近最大输入缓存大小
client_recent_max_output_buffer:0  # 当前客户端最近最大输出缓存大小
blocked_clients:0                  # 正在等待阻塞命令（BLPOP、BRPOP、BRPOPLPUSH）的客户端的数量

# Memory
used_memory:148180600              # Redis分配器分配的内存总量，以字节（byte）为单位
used_memory_human:1015.52K         # 以人类可读的格式返回Redis分配的内存总量，意思就是让我们正常人能看懂呗，带有单位
used_memory_rss:3293184            # 从操作系统的角度，返回 Redis 已分配的内存总量(俗称常驻集大小)。这个值和top、ps等命令的输出一致
used_memory_rss_human:3.14M        # 以人类可读的格式，返回 Redis 已分配的内存总量(俗称常驻集大小)；这个值和top、ps等命令的输出一致
used_memory_peak:1040976           # redis的内存消耗峰值(以字节为单位)，也就是峰值时占用内存大小
used_memory_peak_human:1016.58K    # 以人类可读的格式返回redis的内存消耗峰值
used_memory_peak_perc:99.90%       # (used_memory/used_memory_peak) *100%，内存峰值占用率
used_memory_overhead:1037198       # redis为了维护数据集的内部机制所需的内存开销，包括所有客户端输出缓冲区、查询缓冲区、AOF重写缓冲区和主从复制的backlog
used_memory_startup:987504         # Redis在启动时消耗的初始内存量(以字节为单位)
used_memory_dataset:2690           # 数据集的字节大小used_memory—used_memory_overhead
used_memory_dataset_perc:5.14%     # 净内存使用量的百分比(used_memory_dataset/(used_memory—used_memory_startup))*100%
total_system_memory:8589934592     # 整个系统内存
total_system_memory_human:16.00G   # 正常人可以看懂的格式显示  系统内存大小 带单位
used_memory_lua:37888              # Lua脚本存储占用的内存
used_memory_lua_human:37.00K       # 正常人可看懂的格式显示Lua脚本存储占用的内存 带单位
used_memory_scripts:0              # 缓存的Lua脚本使用的字节数
used_memory_scripts_human:0B       # 正常人可看懂的格式显示  缓存的Lua脚本使用的字节数 带单位
maxmemory:0                        # Redis实例的最大内存配置 字节数
maxmemory_human:0B                 # 正常人可看懂格式显示 最大内存配置 带单位
maxmemory_policy:noeviction        # 当达到maxmemory时的淘汰策略
allocator_frag_ratio:3.24
allocator_frag_bytes:2249712
allocator_rss_ratio:1.00
allocator_rss_bytes:0
rss_overhead_ratio:1.01
rss_overhead_bytes:37888
mem_fragmentation_ratio:3.27
mem_fragmentation_bytes:2287600
mem_not_counted_for_evict:0
mem_replication_backlog:0
mem_clients_slaves:0
mem_clients_normal:49694
mem_aof_buffer:0
mem_allocator:libc                # 内存分配器
active_defrag_running:0           # 表示没有活动的defrag任务正在运行，1表示有活动的defrag任务正在运行(defrag:表示内存碎片整理)
lazyfree_pending_objects:0        # 0表示不存在延迟释放(也有资料翻译未惰性删除)的挂起对象

# Persistence
loading:0                         # 服务器是否正在载入持久化文件
rdb_changes_since_last_save:5     # 离最近一次成功生成rdb文件，写入命令的个数，即有多少个写入命令没有持久化
rdb_bgsave_in_progress:0          # 服务器是否正在创建rdb文件
rdb_last_save_time:1620033801     # 上一次成功保存RDB的基于纪元的时间戳 秒
rdb_last_bgsave_status:ok         # 最近一次rdb持久化是否成功
rdb_last_bgsave_time_sec:-1       # 最近一次成功生成rdb文件耗时时间(以秒为单位)
rdb_current_bgsave_time_sec:-1    # 正在进行的RDB保存操作的持续时间(以秒为单位)
rdb_last_cow_size:0               # 上一次RDB保存操作期间写时复制内存的大小(以字节为单位)
aof_enabled:0                     # 是否开启了aof
aof_rewrite_in_progress:0         # 标识aof的rewrite操作是否在进行中
aof_rewrite_scheduled:0           # 如果rdb保存完成之后执行rewrite
aof_last_rewrite_time_sec:-1      # 最近一次aof rewrite耗费的时长(以秒为单位)
aof_current_rewrite_time_sec:-1   # 如果rewrite操作正在进行，则记录所使用的时间(以秒为单位)
aof_last_bgrewrite_status:ok      # 上次bgrewriteaof操作的状态
aof_last_write_status:ok          # 上次aof写入状态
aof_last_cow_size:0               # 最近一次aof重写时复制内存的大小(以字节为单位)

# Stats
total_connections_received:1      # 务器接受的连接总数(过度地创建和销毁连接对性能有影响)
total_commands_processed:3        # redis处理的命令总数
instantaneous_ops_per_sec:0       # redis每秒处理的命令数，就是qps
total_net_input_bytes:63          # redis网络读取流量的总字节数
total_net_output_bytes:14765      # redis网络写入流量的总字节数
instantaneous_input_kbps:0.00     # redis网络入口kps，以KB/秒为单位
instantaneous_output_kbps:0.00    # redis网络出口kps，以KB/秒为单位
rejected_connections:0            # redis连接个数达到maxclients限制，拒绝新连接的个数
sync_full:0                       # 主从完全同步成功次数
sync_partial_ok:0                 # 主从部分同步成功次数
sync_partial_err:0                # 主从部分同步失败次数
expired_keys:0                    # redis运行以来过期的key的数量
expired_stale_perc:0.00           # key过期的比率
expired_time_cap_reached_count:0  # key过期次数
evicted_keys:0                    # redis运行以来剔除(超过了maxmemory后)的key的数量
keyspace_hits:0                   # 查找键成功的数量，也就是命中的数量
keyspace_misses:0                 # 查找键失败的数量，也就是未命中的数量
pubsub_channels:0                 # redis当前使用中的频道数量
pubsub_patterns:0                 # 当前使用的模式的数量
latest_fork_usec:0                # 最近一次fork操作阻塞redis进程的耗时数，单位微秒
migrate_cached_sockets:0          # 是否已经缓存了到该地址的连接
slave_expires_tracked_keys:0      # redis从实例到期key数量
active_defrag_hits:0              # redis主动进行碎片整理命中次数
active_defrag_misses:0            # redis主动进行碎片整理未命中次数
active_defrag_key_hits:0          # redis主动进行碎片整理key命中次数
active_defrag_key_misses:0        # redis主动进行碎片整理key未命中次数

# Replication
role:master                       # redis实例的角色，是master or slave
connected_slaves:0                # 连接的从slave实例个数
master_replid:1e913ad6101de7d40fcea32378f515e62a55c9db   # master实例启动随机字符串
master_replid2:0000000000000000000000000000000000000000  # master实例启动随机字符串2，辅助作用，用于故障转移后的同步
master_repl_offset:0              # redis的当前主从偏移量
second_repl_offset:-1             # redis的当前主从偏移量2
repl_backlog_active:0             # 复制积压缓冲区是否开启
repl_backlog_size:1048576         # 复制积压缓冲大小 
repl_backlog_first_byte_offset:0  # 复制缓冲区里偏移量的大小
repl_backlog_histlen:0            # 复制积压缓冲区中数据的大小(以字节为单位)，值等于master_repl_offset-repl_backlog_first_byte_offset

# CPU
used_cpu_sys:3.629912             # Redis服务器消耗的系统CPU，这是服务器进程的所有线程(主线程和后台线程)消耗的系统CPU的总和 
used_cpu_user:2.675796            # Redis服务器消耗的用户CPU，这是服务器进程的所有线程(主线程和后台线程)消耗的用户CPU的总和
used_cpu_sys_children:0.000000    # 后台进程消耗的系统CPU累计总和 
used_cpu_user_children:0.000000   # 后台进程消耗的用户CPU累计总和

# Cluster
cluster_enabled:0                 # 实例是否启用集群模式

# Keyspace
db0：keys = 749916                # db0的key的数量
expires = 8                      # 含有生存期的key的数
avg_ttl = 138855028143523        # 平均存活时间

作者：我是阿沐
链接：https://juejin.cn/post/6958182577878335525
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
~~~

