# MongoDB

## 1、软件下载安装

### 1、下载

社区版：https://www.mongodb.com/try/download/community



### 2、安装

解压后，将改目录放入$PATH



### 3、配置

1、新建启动时数据的存储目录

~~~shell
# 日志
mkdir -p /var/log/mongodb/
# 数据,4.x的版本改到这个/data/db目录下了，启动前需创建
mkdir -p /var/lib/mongo/
# 程序标识符PID,4.x的版本在/tmp/mongodb-27017.sock下
mkdir -p /var/run/mongodb/
~~~



2、配置文件

官方说明文档：https://docs.mongodb.com/manual/reference/configuration-options/

~~~shell
vim /opt/mongodb/conf/mongo.conf
~~~



~~~nginx
# 日志配置
systemLog:
   destination: file
   path: "/var/log/mongodb/mongod.log"
   logAppend: true
# 存储配置
storage:
   dbPath: "/var/lib/mongo"
   journal:
      enabled: true
processManagement:
   fork: true
net:
   bindIp: 127.0.0.1
   port: 27017
setParameter:
   enableLocalhostAuthBypass: false
~~~



### 4、启动

~~~shell
./mongod -f /opt/mongodb/conf/mongo.conf
~~~



### 5、停止

~~~shell
# 1、kill掉
# 2、使用mongo命令连接上mongo后执行
use admin
db.shutdownServer()
quit()
~~~



### 6、新增账户

~~~shell
db.createUser({user:"root",pwd:"123456",roles:["root"]})
~~~



### 7、服务自启动

1、关闭selinux

~~~shell
vim /etc/selinux/config
# 修改配置SELINUX=disabled
# 重启机器
reboot
~~~



2、修改目录所有者

~~~shell
chown -R 用户名:用户名 目录
~~~



3、新增服务

~~~shell
vim /lib/systemd/system/mongod.service
~~~



~~~shell
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target
Documentation=https://docs.mongodb.org/manual

[Service]
User=cg
Group=cg
ExecStart=/usr/bin/mongod -f /opt/mongodb/conf/mongo.conf
PIDFile=/var/run/mongodb/mongod.pid
# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=64000
# processes/threads
LimitNPROC=64000
# locked memory
LimitMEMLOCK=infinity
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false
# Transparent_hugepages disabled  # 取消Linux的透明大页内存设置
PermissionsStartOnly=true
# ExecStartPre=/bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
# ExecStartPre=/bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/defrag"


# Recommended limits for for mongod as specified in
# http://docs.mongodb.org/manual/reference/ulimit/#recommended-settings

[Install]
WantedBy=multi-user.target
~~~



~~~shell
systemctl enable mongod.service
~~~

